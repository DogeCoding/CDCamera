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
    lazy var captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .unspecified)
    
    // 是视频模式 否则live photo
    fileprivate var isVideoStatus = true
    
    var photoSetting: AVCapturePhotoSettings?
    var deviceInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureVideoDataOutput?
    var previewPhotoLayer: AVCaptureVideoPreviewLayer?
    var previewVideoLayer: CALayer?
    var gridLayer: CALayer?
    
    var faceObjcet: AVMetadataFaceObject?
    
    var assetWriter: AVAssetWriter?
    var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor?
    var isWriting = false
    
    var currentSampleTime: CMTime?
    var currentVideoDimensions: CMVideoDimensions?
    
    var capturedImage: UIImage?
    var ciImage: CIImage?
    
    // 滤镜
    var filter: CIFilter?
    lazy var context: CIContext = {
        let eaglContext = EAGLContext(api: .openGLES2)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    
    // 视频分辨率
    var videoWidth: CGFloat = 480
    var videoHeight: CGFloat = 640
    var videoScale: CGFloat {
        return videoHeight / videoWidth
    }
    
    var isFrontCamera: Bool = false
    
    // 画面缩放
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
    
    var cameraDevices: [AVCaptureDevice] {
        get {
            return AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: .video, position: .unspecified).devices
        }
    }
    
    // 闪光灯
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
    
    // MARK: - Life Cricle
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
    
    // MARK: - Private
    fileprivate func setupCaptureSession() {
        guard let device = captureDevice else { return }
    
        changePreset(width: videoWidth, height: videoHeight)
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        deviceInput = try? AVCaptureDeviceInput(device: device)
        guard let deviceInput = deviceInput else { return }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
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
        
        guard let videoOutput = videoOutput else { return }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        previewPhotoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewPhotoLayer?.videoGravity = .resizeAspect
        previewPhotoLayer?.frame = view.bounds
        view.layer.insertSublayer(previewPhotoLayer!, at: 0)
        previewPhotoLayer?.isHidden = true
        
        previewVideoLayer = CALayer()
        previewVideoLayer?.anchorPoint = .zero
        previewVideoLayer?.bounds = view.bounds
        view.layer.insertSublayer(previewVideoLayer!, at: 0)
		
		let connection = videoOutput.connection(with: .video)
		connection?.videoOrientation = .portrait
		if let bool = connection?.isVideoMirroringSupported, bool {
			connection?.isVideoMirrored = true
		}
        
        // 人脸检测
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
        }
    }
    
    fileprivate func setupScaleGesture() {
        scaleGusture = UIPinchGestureRecognizer(target: self, action: #selector(handleScaleGesture(recoginer:)))
        view.addGestureRecognizer(scaleGusture!)
    }
    
    // 网格线
    fileprivate func setupGridLayer() {
        if let layer = gridLayer {
            layer.removeFromSuperlayer()
            gridLayer = nil
        }
        gridLayer = CALayer()
        let layerWidth = view.width
        let layerHeight = layerWidth * videoScale
        gridLayer?.frame = CGRect(x: 0, y: (view.height - layerHeight) / 2, width: layerWidth, height: layerHeight)
        let lineWidth: CGFloat = 1 / ScreenScale
        gridLine(withFrame: CGRect(x: (view.width - 2 * lineWidth) / 3 , y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: (view.width - 2 * lineWidth) / 3 * 2.0 + lineWidth, y: 0, width: lineWidth, height: layerHeight))
        gridLine(withFrame: CGRect(x: 0, y: (layerHeight - 2 * lineWidth) / 3, width: view.width, height: lineWidth))
        gridLine(withFrame: CGRect(x: 0, y: (layerHeight - 2 * lineWidth) / 3 * 2.0, width: view.width, height: lineWidth))
        
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
    
    // 保存视频
    fileprivate func saveMovieToCameraRoll(_ finishBlock: @escaping () -> Void) {
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.movieURL())
            }
        } catch _ as NSError {
            checkForAndDeleteFile()
        }
        finishBlock()
    }
    
    // 视频保存路径
    fileprivate func movieURL() -> URL {
        let tempDir = NSTemporaryDirectory()
        return URL(fileURLWithPath: tempDir).appendingPathComponent("test.mp4")
    }
    
    // 删除之前的临时文件
    fileprivate func checkForAndDeleteFile() {
        let fm = FileManager.default
        let url = movieURL()
        if fm.fileExists(atPath: url.path) {
            do {
                try fm.removeItem(at: url)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func createWriter() {
        checkForAndDeleteFile()
        
        do {
            assetWriter = try AVAssetWriter(outputURL: movieURL(), fileType: .mp4)
        } catch let error as NSError {
            print("创建writer失败")
            print(error.localizedDescription)
            return
        }
        
        let outputSettings = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : Int(currentVideoDimensions!.width),
        AVVideoHeightKey : Int(currentVideoDimensions!.height)] as [String : Any]
        
        let assetWriterVideoInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        assetWriterVideoInput.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
        
        let sourcePixelBufferAttributesDictionary = [
            String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_32BGRA),
            String(kCVPixelBufferWidthKey) : Int(currentVideoDimensions!.width),
            String(kCVPixelBufferHeightKey) : Int(currentVideoDimensions!.height),
        String(kCVPixelFormatOpenGLESCompatibility) : kCFBooleanTrue] as [String : Any]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        if assetWriter!.canAdd(assetWriterVideoInput) {
            assetWriter!.add(assetWriterVideoInput)
        } else {
            print("不能添加视频writer的input \(assetWriterVideoInput)")
        }
    }
    
    fileprivate func makeFaceWithCIImage(inputImage: CIImage, faceObjcet: AVMetadataFaceObject) -> CIImage {
        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(max(inputImage.extent.size.width, inputImage.extent.size.height) / 60, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter?.outputImage
        
        var maskImage: CIImage!
        let faceBounds = faceObjcet.bounds
        
        let centerX = inputImage.extent.size.width * (faceBounds.origin.x + faceBounds.size.width / 2)
        let centerY = inputImage.extent.size.height * (1 - faceBounds.origin.y - faceBounds.size.height / 2)
        let radius = faceBounds.size.width * inputImage.extent.size.width / 2
        let radialGradient = CIFilter(name: "CIRadialGradient",
                                      withInputParameters: [
                                        "inputRadius0" : radius,
                                        "inputRadius1" : radius + 1,
                                        "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                        "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                        kCIInputCenterKey : CIVector(x: centerX, y: centerY)
            ])!
        
        let radiaGradientOutputImage = radialGradient.outputImage!.cropped(to: inputImage.extent)
        if maskImage == nil {
            maskImage = radiaGradientOutputImage
        } else {
            print(radiaGradientOutputImage)
            maskImage = CIFilter(name: "CISourceOverCompositing",
                                 withInputParameters: [
                                    kCIInputImageKey : radiaGradientOutputImage,
                                    kCIInputBackgroundImageKey : maskImage
                ])!.outputImage
        }
        
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        
        return blendFilter.outputImage!
    }
    
    // 预览缩放
    @objc fileprivate func handleScaleGesture(recoginer: UIPinchGestureRecognizer) {
        guard let previewPhotoLayer = previewPhotoLayer else { return }
        var allTouchsAreOnThePreviewLayer = true
        for i in 0..<recoginer.numberOfTouches {
            let location = recoginer.location(ofTouch: i, in: view)
            let convertdLocation = previewPhotoLayer.convert(location, from: previewPhotoLayer.superlayer)
            if !previewPhotoLayer.contains(convertdLocation) {
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
            previewPhotoLayer.setAffineTransform(CGAffineTransform(scaleX: effectScale, y: effectScale))
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
    
    // MARK: - 相机操作
    // 更改比例
    @objc func changePreset(width: CGFloat, height: CGFloat) {
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        var sessionPreset: AVCaptureSession.Preset!
        switch((height, width)) {
        case (640, 480):
            sessionPreset = .vga640x480
        case (1280, 720):
            sessionPreset = .hd1280x720
        default:
            sessionPreset = .hd4K3840x2160
        }
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }
    }
    
    // 自动对焦 白平衡 曝光
    @objc func touch(withPoint point: CGPoint, num: Int) {
        var _previewLayer = previewVideoLayer
        if !isVideoStatus {
            _previewLayer = previewPhotoLayer
        }
        guard let device = captureDevice, let previewLayer = _previewLayer else { return }
        var convertedPoint = previewLayer.convert(point, from: previewLayer.superlayer)
        
        print("yfk \(point) convert: \(convertedPoint)")
        let videoWidth = view.width
        let videoHeight = videoWidth * videoScale
        convertedPoint = CGPoint(x: CGFloat(convertedPoint.x / view.width), y: CGFloat(convertedPoint.y / view.height))
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
//        guard let v = videoOrientationFromCurrentDeviceOrientation, let connection = previewLayer?.connection else {
//            return
//        }
//        if connection.isVideoOrientationSupported {
//            connection.videoOrientation = v
//            photoOutput?.connection(with: .video)?.videoOrientation = v
//            videoOutput?.connection(with: .video)?.videoOrientation = v
//        }
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
            faceObjcet = nil
            
            OnMainThreadAsync {
                if isAnimate {
                    self.previewPhotoLayer?.add(animation, forKey: nil)
                    self.previewVideoLayer?.add(animation, forKey: nil)
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

                } else {
                    if let deviceInput = self.deviceInput {
                        self.captureSession.addInput(deviceInput)
                    }
                    return
                }
            }
        }
    }
    
    // 拍照
    @objc func captureImage(sender: UIButton) {
        guard let ciImage = ciImage, isWriting == false else { return }
        
        sender.isEnabled = false
        captureSession.stopRunning()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let captureImage = UIImage(cgImage: cgImage)
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: captureImage)
            }
            captureSession.startRunning()
            sender.isEnabled = true
        } catch let error as NSError {
            OnMainThreadAsync {
                let alert = UIAlertController(title: "错误", message: error.localizedDescription, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        capturedImage = captureImage
        OnMainThreadAsync {
            self.capturedImageHandler()
        }
    }
    
    // 录制视频
    @objc func record() {
        if isWriting {
            isWriting = false
            assetWriterPixelBufferInput = nil
            assetWriter?.finishWriting{ [unowned self] () -> Void in
                OnMainThreadAsync {
                    self.videoRecordWillFinish()
                }
                self.saveMovieToCameraRoll {
                    OnMainThreadAsync {
                        self.videoRecordFinished()
                    }
                }
            }
        } else {
            guard let currentSampleTime = currentSampleTime else { return }
            createWriter()
            OnMainThreadAsync {
                self.videoRecordProcessing()
            }
            assetWriter?.startWriting()
            assetWriter?.startSession(atSourceTime: currentSampleTime)
            isWriting = true
        }
    }
    
    // MARK: - Notification
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
    
    
    // MARK: - Public
    func capturedImageHandler() {
        
    }
    
    func videoRecordProcessing() {
        
    }
    
    func videoRecordWillFinish() {
        
    }
    
    func videoRecordFinished() {
        
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
        autoreleasepool {
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)!
            currentVideoDimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
            
            var outputImage = CIImage(cvPixelBuffer: imageBuffer)
            
            if filter != nil {
                filter?.setValue(outputImage, forKey: kCIInputImageKey)
                if filter?.outputImage != nil {
                    outputImage = filter!.outputImage!
                }
            }
            
            if faceObjcet != nil {
                outputImage = makeFaceWithCIImage(inputImage: outputImage, faceObjcet: faceObjcet!)
            }
            
            if isWriting {
                if assetWriterPixelBufferInput?.assetWriterInput.isReadyForMoreMediaData == true {
                    var newPixelBuffer: CVPixelBuffer? = nil
                    
                    CVPixelBufferPoolCreatePixelBuffer(nil, assetWriterPixelBufferInput!.pixelBufferPool!, &newPixelBuffer)
                    
                    context.render(outputImage, to: newPixelBuffer!, bounds: outputImage.extent, colorSpace: nil)
                    
                    let success = assetWriterPixelBufferInput?.append(newPixelBuffer!, withPresentationTime: self.currentSampleTime!)
                    
                    if success == false {
                        print("Pixel Buffer没有附加成功")
                    }
                }
            }
            
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
            
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
            ciImage = outputImage
            
            OnMainThreadAsync {
                self.previewVideoLayer?.contents = cgImage
            }
        }
    }
}

extension BaseCameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            faceObjcet = metadataObjects.first as? AVMetadataFaceObject
        } else {
            faceObjcet = nil
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
