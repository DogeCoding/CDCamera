//
//  HomeCameraViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class HomeCameraViewController: BaseCameraViewController {
    
    var switchCameraBtn: BaseButton?
    var captureBtn: BaseButton?
    lazy var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonUI()
        setupTopControl()
        setupBottomControl()
    }
    
    fileprivate func setupCommonUI() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        view.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapGesture))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupTopControl() {
        switchCameraBtn = BaseButton(type: .custom)
        switchCameraBtn?.setImage(UIImage(named: "camera_switch"), for: .normal)
        switchCameraBtn?.size = CGSize(width: 50, height: 50)
        switchCameraBtn?.top = 20
        switchCameraBtn?.centerX = view.centerX
        switchCameraBtn?.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
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
    
    @objc fileprivate func imageViewTapGesture() {
        imageView.isHidden = true
    }
}
