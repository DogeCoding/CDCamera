//
//  BaseCameraViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/13.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

enum CDCameraDeviceStatus {
    case off, on, auto
}

class BaseCameraViewController: UIViewController {
    
    lazy var captureSession = AVCaptureSession()
    lazy var captureDevice = AVCaptureDevice.default(for: .video)
    var photoSetting: AVCapturePhotoSettings?
    var deviceInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var gridLayer: CALayer?
    
    var videoWidth: CGFloat = 480
    var videoHeight: CGFloat = 640
    
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
    
    fileprivate var _isOpenTorch: Bool = false
    var isOpenTorch: Bool {
        set {
            if newValue {
                changeTorchMode(torchMode: .on)
            } else {
                changeTorchMode(torchMode: .off)
            }
            _isOpenTorch = newValue
        }
        get {
            return _isOpenTorch
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
        setupAVCaptureSession()
        setupScaleGesture()
        setupGridLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
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
    fileprivate func setupAVCaptureSession() {
        guard let device = captureDevice else { return }
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        var sessionPreset: AVCaptureSession.Preset = .photo
        switch((videoHeight, videoWidth)) {
        case (640, 480):
            sessionPreset = .vga640x480
        case (1280, 720):
            sessionPreset = .hd1280x720
        default:
            sessionPreset = .photo
        }
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }
        
        do {
            try deviceInput = AVCaptureDeviceInput(device: device)
            photoOutput = AVCapturePhotoOutput()
            
            photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            photoSetting?.isAutoStillImageStabilizationEnabled = true
            photoSetting?.isHighResolutionPhotoEnabled = true
            if photoOutput!.supportedFlashModes.contains(.auto) {
                photoSetting?.flashMode = .auto
            }
            
            photoOutput?.isHighResolutionCaptureEnabled = true
            photoOutput?.setPreparedPhotoSettingsArray([photoSetting!], completionHandler: nil)
            
            guard let deviceInput = deviceInput, let photoOutput = photoOutput else { return }
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspect
            previewLayer?.frame = view.bounds
            view.layer.insertSublayer(previewLayer!, at: 0)
        } catch {
            
        }
        
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
        let scale = videoHeight / videoWidth
        let layerWidth = view.width
        let layerHeight = layerWidth * scale
        gridLayer?.frame = CGRect(x: 0, y: (view.height - layerHeight)/2, width: layerWidth, height: layerHeight)
        let lineWidth: CGFloat = 1
        gridLine(withFrame: CGRect(x: (view.width - 2*lineWidth)/3 , y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: (view.width - 2*lineWidth)/3*2.0 + lineWidth, y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: 0, y: (view.height - 2*lineWidth)/3, width: view.width, height: lineWidth))
        gridLine(withFrame: CGRect(x: 0, y: (view.height - 2*lineWidth)/3*2.0, width: lineWidth, height: layerHeight))
        
        view.layer.addSublayer(gridLayer!)
    }
    
    fileprivate func gridLine(withFrame frame: CGRect) {
        guard let gridLayer = gridLayer else { return }
        let line = CALayer()
        line.frame = frame
        line.backgroundColor = UIColor.white.cgColor
        gridLayer.addSublayer(line)
    }
    
    // 摄像头配置
    fileprivate func configureCaptureDevice(device: AVCaptureDevice) -> AVCaptureDevice? {
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
    
    // MARK: --- 相机操作 ---
    // 自动对焦 白平衡 曝光
    @objc func touch(withPoint point: CGPoint) {
        guard let device = captureDevice else { return }
        assert((point.x>=0 && point.x<1)&&(point.y>=0 && point.y<1), "触摸点错误")
        
        do {
            try device.lockForConfiguration()
            defer {
                device.unlockForConfiguration()
            }
            if device.isFocusModeSupported(.continuousAutoFocus), device.isFocusPointOfInterestSupported {
                device.focusMode = .continuousAutoFocus
                device.focusPointOfInterest = point
            }
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            if device.isExposureModeSupported(.continuousAutoExposure), device.isExposurePointOfInterestSupported {
                device.exposureMode = .continuousAutoExposure
                device.exposurePointOfInterest = point
            }
        } catch _ as NSError {
            
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
        guard let v = videoOrientationFromCurrentDeviceOrientation else {
            return
        }
        previewLayer?.connection?.videoOrientation = v
        photoOutput?.connection(with: .video)?.videoOrientation = v
    }
    
    // 切换摄像头
    @objc func switchCamera() {
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
            
            OnMainThreadAsync {
                self.previewLayer?.add(animation, forKey: nil)
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
                let capturePhotoSetting = AVCapturePhotoSettings.init(from: photoSetting)
                videoConnection.videoOrientation = (previewLayer.connection?.videoOrientation)!
                self.photoOutput?.capturePhoto(with: capturePhotoSetting, delegate: self)
            }
        }
    }
    
    // MARK: --- Public ---
    @objc func applicationWillResignActive() {
        
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
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
