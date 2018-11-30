//
//  BaseCameraViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/13.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import CoreImage

enum CDCameraDeviceStatus {
    case off, on, auto
}

class BaseCameraViewController: UIViewController {
    
    lazy var captureSession = AVCaptureSession()
    lazy var captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
    var photoSetting: AVCapturePhotoSettings?
    var deviceInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var videoLayer: CALayer?
    var gridLayer: CALayer?
    
    var filter: CIFilter?
    lazy var context: CIContext = {
        let eaglContext = EAGLContext(api: .openGLES2)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    
    var videoWidth: CGFloat = 480
    var videoHeight: CGFloat = 640
    var videoScale: CGFloat {
        return videoHeight / videoWidth
    }
    
    var isFrontCamera: Bool = false
    
    var isEableScale: Bool {
        set {
            scaleGusture?.isEnabled = newValue
        }
        get {
            if scaleGusture == nil {
                return false
            }
            return scaleGusture!.isEnabled
        }
    }
    var scaleGusture: UIPinchGestureRecognizer?
    var beginScale: CGFloat = 1.0
    var effectScale: CGFloat = 1.0
    
    var capturedImage: UIImage?
    
    var cameraDevices: [AVCaptureDevice] {
        get {
            return AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        }
    }
    
    fileprivate var _isTorchOn: Bool = false
    var isTorchOn: Bool {
        set {
            if isFrontCamera {
                return
            }
            if newValue {
                changeTorchMode(torchMode: .on)
            } else {
                changeTorchMode(torchMode: .off)
            }
            _isTorchOn = newValue
        }
        get {
            return _isTorchOn
        }
    }
    
    // 根据当前设备的状态计算捕捉到的图像的状态
    fileprivate var videoOrientationFromCurrentDeviceOrientation: AVCaptureVideoOrientation? {
        get {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            case .portrait:
                return .portrait
            default:
                return nil
            }
        }
    }
    
    // MARK: --- Life Cricle ---
    override func viewDidLoad() {
        setupCaptureSession()
        _ = configureCaptureDevice(device: captureDevice)
        isTorchOn = false
        setupScaleGesture()
        setupGridLayer()
        findFormat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avcaptureRuntimeError(_:)), name: .AVCaptureSessionRuntimeError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceWasConnect), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceWasDisconnect), name: .AVCaptureDeviceWasDisconnected, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: --- Private ---
    fileprivate func setupCaptureSession() {
        guard let device = captureDevice else { return }
    
        changePreset(width: videoWidth, height: videoHeight)
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        deviceInput = try? AVCaptureDeviceInput(device: device)
        guard let deviceInput = deviceInput else { return }
        
        photoOutput = AVCapturePhotoOutput()
        
        photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        photoSetting?.isAutoStillImageStabilizationEnabled = true
        photoSetting?.isHighResolutionPhotoEnabled = true
        if photoOutput!.supportedFlashModes.contains(.auto) {
            photoSetting?.flashMode = .auto
        }
        
        photoOutput?.isHighResolutionCaptureEnabled = true
        photoOutput?.setPreparedPhotoSettingsArray([photoSetting!], completionHandler: nil)
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
        videoOutput?.alwaysDiscardsLateVideoFrames = true
        
        let videoBufferQueue = DispatchQueue(label: "CDVideoBufferQueue")
        videoOutput?.setSampleBufferDelegate(self, queue: videoBufferQueue)
        
        guard let photoOutput = photoOutput, let videoOutput = videoOutput else { return }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspect
        previewLayer?.frame = view.bounds
//            view.layer.insertSublayer(previewLayer!, at: 0)
        
        videoLayer = CALayer()
        videoLayer?.anchorPoint = .zero
        videoLayer?.bounds = view.bounds
        view.layer.insertSublayer(videoLayer!, at: 0)
    }
    
    fileprivate func setupScaleGesture() {
        scaleGusture = UIPinchGestureRecognizer(target: self, action: #selector(handleScaleGesture(recoginer:)))
        view.addGestureRecognizer(scaleGusture!)
        isEableScale = true
    }
    
    fileprivate func setupGridLayer() {
        if let layer = gridLayer {
            layer.removeFromSuperlayer()
            gridLayer = nil
        }
        gridLayer = CALayer()
        let layerWidth = view.width
        let layerHeight = layerWidth * videoScale
        gridLayer?.frame = CGRect(x: 0, y: (view.height - layerHeight)/2, width: layerWidth, height: layerHeight)
        let lineWidth: CGFloat = 1 / ScreenScale
        gridLine(withFrame: CGRect(x: (view.width - 2*lineWidth)/3 , y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: (view.width - 2*lineWidth)/3*2.0 + lineWidth, y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: 0, y: (layerHeight - 2*lineWidth)/3, width: view.width, height: lineWidth))
        gridLine(withFrame: CGRect(x: 0, y: (layerHeight - 2*lineWidth)/3*2.0, width: view.width, height: lineWidth))
        
        view.layer.addSublayer(gridLayer!)
    }
    
    fileprivate func gridLine(withFrame frame: CGRect) {
        guard let gridLayer = gridLayer else { return }
        let line = CALayer()
        line.frame = frame
        line.backgroundColor = UIColorFromRGB(rgbValue: 0x8F898B, alphaValue: 0.7).cgColor
        gridLayer.addSublayer(line)
    }
    
    // 摄像头配置
    fileprivate func configureCaptureDevice(device: AVCaptureDevice?) -> AVCaptureDevice? {
        guard let device = device else { return nil }
        do {
            try device.lockForConfiguration()
            defer {
                device.unlockForConfiguration()
            }

            if device.isFocusModeSupported(.autoFocus) {
                device.focusMode = .autoFocus
            }
            if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                device.whiteBalanceMode = .autoWhiteBalance
            }
            if device.isExposureModeSupported(.autoExpose) {
                device.exposureMode = .autoExpose
            }
            return device
        } catch {
            return nil
        }
    }
    
    // 获取摄像头
    fileprivate func camera(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: position).devices
        
        for device in devices {
            if device.position == position {
                return configureCaptureDevice(device: device)
            }
        }
        return nil
    }
    
    @objc fileprivate func handleScaleGesture(recoginer: UIPinchGestureRecognizer) {
        guard let previewLayer = previewLayer else { return }
        var allTouchsAreOnThePreviewLayer = true
        for i in 0..<recoginer.numberOfTouches {
            let location = recoginer.location(ofTouch: i, in: view)
            let convertdLocation = previewLayer.convert(location, from: previewLayer.superlayer)
            if !previewLayer.contains(convertdLocation) {
                allTouchsAreOnThePreviewLayer = false
                break
            }
        }
        
        if allTouchsAreOnThePreviewLayer {
            effectScale = beginScale * recoginer.scale
            effectScale = effectScale < 1 ? 1 : effectScale
            
            guard let maxScaleAndCropFactor = photoOutput?.connection(with: .video)?.videoMaxScaleAndCropFactor else { return }
            effectScale = effectScale > maxScaleAndCropFactor ? maxScaleAndCropFactor : effectScale
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            previewLayer.setAffineTransform(CGAffineTransform(scaleX: effectScale, y: effectScale))
            CATransaction.commit()
        }
    }
    
    fileprivate func findFormat() {
        guard let avcaptureFormat = captureDevice?.formats else { return }
        for format in avcaptureFormat {
            print("yfk avcaptureFormat: \(format)")
        }

    }
    
    fileprivate func findFilter() {
        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn) as [String]
        for name in filterNames {
            print("yfk filterName: \(name)")
        }
    }
    
    // MARK: --- 相机操作 ---
    // 更改比例
    @objc func changePreset(width: CGFloat, height: CGFloat) {
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        var sessionPreset: AVCaptureSession.Preset = .photo
        switch((height, width)) {
        case (640, 480):
            sessionPreset = .vga640x480
        case (1280, 720):
            sessionPreset = .hd4K3840x2160
        default:
            sessionPreset = .photo
        }
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }
    }
    
    // 自动对焦 白平衡 曝光
    @objc func touch(withPoint point: CGPoint, num: Int) {
        guard let device = captureDevice, let previewLayer = previewLayer else { return }
        var convertedPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
        print("yfk \(point) convert: \(convertedPoint)")
//        let videoWidth = view.width
//        let videoHeight = videoWidth * videoScale
//        var point = CGPoint(x: CGFloat(point.x / view.width), y: CGFloat(point.y / view.height))
        if isFrontCamera {
            convertedPoint = CGPoint(x: 1 - convertedPoint.x, y: 1 - convertedPoint.y)
        }
        assert((convertedPoint.x>=0 && convertedPoint.x<1)&&(convertedPoint.y>=0 && convertedPoint.y<1), "触摸点错误")
        
        do {
            try device.lockForConfiguration()
            defer {
                device.unlockForConfiguration()
            }
            if device.isFocusModeSupported(.continuousAutoFocus), device.isFocusPointOfInterestSupported {
                device.focusMode = .continuousAutoFocus
                device.focusPointOfInterest = convertedPoint
            }
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            if device.isExposureModeSupported(.continuousAutoExposure), device.isExposurePointOfInterestSupported {
                device.exposureMode = .continuousAutoExposure
                device.exposurePointOfInterest = convertedPoint
            }
        } catch _ as NSError {
            
        }
        if num-1 > 0 {
            touch(withPoint: point, num: num-1)
        }
    }
    
    // 更改闪光灯模式
    @objc func changeTorchMode(torchMode: AVCaptureDevice.TorchMode) {
        guard let device = captureDevice else { return }
        do {
            try device.lockForConfiguration()
            defer {
                device.unlockForConfiguration()
            }
            if device.isTorchModeSupported(torchMode) {
                device.torchMode = torchMode
            }
            
        } catch _ as NSError {
            
        }
        
    }
    
    // 切换横竖屏
    @objc func changeOrientation() {
        guard let v = videoOrientationFromCurrentDeviceOrientation, let connection = previewLayer?.connection else {
            return
        }
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = v
            photoOutput?.connection(with: .video)?.videoOrientation = v
            videoOutput?.connection(with: .video)?.videoOrientation = v
        }
    }
    
    // 切换摄像头
    @objc func switchCamera(withAnimate isAnimate: Bool) {
        if cameraDevices.count > 1 {
            let animation = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            
            var newCamera: AVCaptureDevice?
            
            guard let position = deviceInput?.device.position else { return }
            switch(position) {
            case .back:
                newCamera = camera(position: .front)
                animation.subtype = kCATransitionFromLeft
                
            case .front:
                newCamera = camera(position: .back)
                animation.subtype = kCATransitionFromRight
                
            case .unspecified:
                newCamera = camera(position: .back)
                animation.subtype = kCATransitionFromRight
            }
            
            guard let camera = newCamera, let newInput = try? AVCaptureDeviceInput(device: camera) else {
                return
            }
            
            isFrontCamera = !isFrontCamera
            
            OnMainThreadAsync {
                if isAnimate {
                    self.previewLayer?.add(animation, forKey: nil)
                }
                self.captureSession.beginConfiguration()
                defer {
                    self.captureSession.commitConfiguration()
                }
                if let deviceInput = self.deviceInput {
                    self.captureSession.removeInput(deviceInput)
                }
                
                if self.captureSession.canAddInput(newInput) {
                    self.captureSession.addInput(newInput)
                    self.deviceInput = newInput
                    
                    self.videoLayer?.bounds = CGRect(x: 0, y: 0, width: self.view.height, height: self.view.width)
                    self.videoLayer?.position = CGPoint(x: self.view.width/2, y: self.view.height/2)
//                    self.videoLayer?.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi/2.0)))
                } else {
                    if let deviceInput = self.deviceInput {
                        self.captureSession.addInput(deviceInput)
                    }
                    return
                }
            }
        }
    }
    
    @objc func captureImage() {
        guard let photoSetting = photoSetting, let previewLayer = previewLayer else { return }
        OnMainThreadAsync {
            if let videoConnection = self.photoOutput?.connection(with: .video) {
                videoConnection.videoScaleAndCropFactor = self.effectScale
                let capturePhotoSetting = AVCapturePhotoSettings.init(from: photoSetting)
                var videoOrientation = (previewLayer.connection?.videoOrientation)!
                if videoOrientation == .landscapeLeft {
                    videoOrientation = .landscapeRight
                } else if videoOrientation == .landscapeRight {
                    videoOrientation = .landscapeLeft
                }
                videoConnection.videoOrientation = videoOrientation
                self.photoOutput?.capturePhoto(with: capturePhotoSetting, delegate: self)
            }
        }
    }
    
    // MARK: --- Notification ---
    @objc func applicationWillResignActive() {
        
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
    @objc func avcaptureRuntimeError(_: Notification) {
        
    }
    
    @objc func deviceWasConnect() {
        
    }
    
    @objc func deviceWasDisconnect() {
        
    }
    
    
    // MARK: --- Public ---
    func capturedImageHandler() {
        
    }
    
    
}

extension BaseCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let captureImage = UIImage.init(data: imageData, scale: 1) else { return }
        capturedImage = captureImage
        capturedImageHandler()
        UIImageWriteToSavedPhotosAlbum(capturedImage!, nil, nil, nil)
    }
    
}

extension BaseCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var outputImage = CIImage(cvPixelBuffer: imageBuffer)
        
        let orientation = UIDevice.current.orientation
        var transform: CGAffineTransform!
        
        switch orientation {
        case .portrait:
            transform = CGAffineTransform(rotationAngle: CGFloat(-.pi / 2.0))
        case .portraitUpsideDown:
            transform = CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0))
        case .landscapeRight:
            transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        default:
            transform = CGAffineTransform(rotationAngle: 0)
        }
        
        outputImage = outputImage.transformed(by: transform)
        
        if filter != nil {
            filter?.setValue(outputImage, forKey: kCIInputImageKey)
            if filter?.outputImage != nil {
                outputImage = filter!.outputImage!
            }
        }
        
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        OnMainThreadAsync {
            self.videoLayer?.contents = cgImage
        }
    }
}

extension BaseCameraViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginScale = effectScale
        }
        return true
    }
}
