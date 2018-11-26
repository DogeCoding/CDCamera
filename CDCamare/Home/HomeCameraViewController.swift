//
//  HomeCameraViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class HomeCameraViewController: BaseCameraViewController {
    
    fileprivate var switchCameraBtn: BaseButton?
    fileprivate var captureBtn: BaseButton?
    fileprivate lazy var imageView = UIImageView()
    
    fileprivate var focusView: UIView = {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        view.layer.borderColor = UIColorFromRGB(rgbValue: 0xF61F01, alphaValue: 0.8).cgColor
        view.layer.borderWidth = 1
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonUI()
        setupTopControl()
        setupBottomControl()
    }
    
    fileprivate func setupCommonUI() {
        view.backgroundColor = .white
        
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        view.addSubview(imageView)
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapGesture))
        imageView.addGestureRecognizer(imageViewTap)
        
        let previewTap = UITapGestureRecognizer(target: self, action: #selector(previewTapGesture(gesture:)))
        previewTap.require(toFail: imageViewTap)
        view.addGestureRecognizer(previewTap)
        
        view.addSubview(focusView)
    }
    
    fileprivate func setupTopControl() {
        switchCameraBtn = BaseButton(type: .custom)
        switchCameraBtn?.setImage(UIImage(named: "camera_switch"), for: .normal)
        switchCameraBtn?.size = CGSize(width: 50, height: 50)
        switchCameraBtn?.top = 20
        switchCameraBtn?.centerX = view.centerX
        switchCameraBtn?.addTarget(self, action: #selector(switchCameraAction), for: .touchUpInside)
        view.addSubview(switchCameraBtn!)
    }
    
    fileprivate func setupRightControl() {
        
    }
    
    fileprivate func setupBottomControl() {
        captureBtn = BaseButton(type: .custom)
        captureBtn?.setImage(UIImage(named: "camera_switch"), for: .normal)
        captureBtn?.size = CGSize(width: 50, height: 50)
        captureBtn?.bottom = view.height - 10
        captureBtn?.centerX = view.centerX
        captureBtn?.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        view.addSubview(captureBtn!)
    }
    
    override func capturedImageHandler() {
        guard let capturedImage = capturedImage else { return }
        imageView.image = capturedImage
        imageView.isHidden = false
        imageView.isUserInteractionEnabled = true
        view.bringSubview(toFront: imageView)
    }
    
    // MARK: --- Actions ---
    @objc fileprivate func switchCameraAction() {
        switchCamera(withAnimate: true)
    }
    
    @objc fileprivate func imageViewTapGesture() {
        imageView.isHidden = true
    }
    
    @objc fileprivate func previewTapGesture(gesture: UITapGestureRecognizer) {
        guard let previewLayer = previewLayer else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: focusView)
        let location = gesture.location(in: view)
        let convertdLocation = previewLayer.convert(location, from: previewLayer.superlayer)
        focusView.center = convertdLocation
        focusView.alpha = 0
        focusView.isHidden = false
        touch(withPoint: convertdLocation)
        UIView.animate(withDuration: 0.2, animations: {
            self.focusView.alpha = 1
        }) { (finish) in
            self.focusView.isHidden = true
        }
    }
}
