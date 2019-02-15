//
//  PrivateCameraViewController.swift
//  CDCamare
//
//  Created by yangfukai on 2019/2/14.
//  Copyright © 2019 杨扶恺. All rights reserved.
//

class PrivateCameraViewController: BaseCameraViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .black
        
        gridLayer?.isHidden = true
        previewPhotoLayer?.isHidden = true
        previewVideoLayer?.isHidden = true
        
        let bgView = UIImageView(image: UIImage(named: "private_bgView"))
        bgView.frame = view.bounds
        view.addSubview(bgView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(sender:)))
        singleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    // MARK: --- Actions ---
    @objc fileprivate func singleTapAction(sender: UIButton) {
        touchShake()
        
        captureImage(sender: sender)
    }
    
    @objc fileprivate func doubleTapAction() {
        touchShake()
        
        record()
    }
}
