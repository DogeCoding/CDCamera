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
    var deviceInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var cameraDevices: [AVCaptureDevice] = []
    
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
        findDevice()
        
        setupAVCaptureSession()
        
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
        if captureSession.canSetSessionPreset(.hd1280x720) {
            captureSession.sessionPreset = .hd1280x720
        }
        captureSession.commitConfiguration()
        
        do {
            try deviceInput = AVCaptureDeviceInput(device: device)
            photoOutput = AVCapturePhotoOutput()
            
            let photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            
            if device.hasFlash {
                photoSetting.flashMode = .auto
            }
            
            photoOutput?.setPreparedPhotoSettingsArray([photoSetting], completionHandler: nil)
            
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
    
    fileprivate func configureCaptureDevice(device: AVCaptureDevice) -> AVCaptureDevice? {
        do {
            try device.lockForConfiguration()

            if device.isFocusModeSupported(.autoFocus) {
                device.focusMode = .autoFocus
            }
            if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                device.whiteBalanceMode = .autoWhiteBalance
            }
            if device.isExposureModeSupported(.autoExpose) {
                device.exposureMode = .autoExpose
            }
            device.unlockForConfiguration()
            return device
        } catch {
            return nil
        }
    }
    
    fileprivate func findDevice() {
        cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        for device in cameraDevices {
            print("device type \(device.localizedName), position \(device.position)")
        }
    }
    
    // MARK: --- 相机操作 ---
    // 自动对焦 白平衡 曝光
    func touch(withPoint point: CGPoint) {
        guard let device = captureDevice else { return }
        assert((point.x>=0 && point.x<1)&&(point.y>=0 && point.y<1), "触摸点错误")
        
        do {
            try device.lockForConfiguration()
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
            device.unlockForConfiguration()
        } catch _ as NSError {
            
        }
    }
    
    // 更改闪光灯模式
    func changeTorchMode(torchMode: AVCaptureDevice.TorchMode) {
        guard let device = captureDevice else { return }
        do {
            try device.lockForConfiguration()
            if device.isTorchModeSupported(torchMode) {
                device.torchMode = torchMode
            }
            device.unlockForConfiguration()
        } catch _ as NSError {
            
        }
    }
    
    // 切换横竖屏
    func changeOrientation() {
        guard let v = videoOrientationFromCurrentDeviceOrientation else {
            return
        }
        previewLayer?.connection?.videoOrientation = v
        photoOutput?.connection(with: .video)?.videoOrientation = v
    }
    
    func switchCamera() {
        
    }
    
    func setCamera(position: AVCaptureDevice.Position) {
        guard cameraDevices.count > 1 else { return }
        for device in cameraDevices {
            if device.position == position {
                let animation = CATransition()
                animation.duration = 0.5
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.type = "oglFlip"
                
                var newCamera: AVCaptureDevice?
                
                guard let inputPosition = deviceInput?.device.position else { return }
                
                switch (inputPosition) {
                case .back: break
                case .front: break
                    
                default: break
                   
                }
            }
        }
    }
    
    // MARK: --- Public ---
    @objc func applicationWillResignActive() {
        
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
}

extension BaseCameraViewController: AVCapturePhotoCaptureDelegate {
    
}
