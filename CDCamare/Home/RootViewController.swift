//
//  RootViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import CDAdditions
import AVFoundation
import AssetsLibrary
import Photos

class RootViewController: UIViewController {
    static let shared: RootViewController = {
        return RootViewController()
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColorFromRGB(rgbValue: 0x303A4D)
        #if DEBUG
        setupFlexBtn()
        #endif
        
        setupCameraBtn()
    }
    
    fileprivate func setupFlexBtn() {
        let flexBtn = UIButton()
        flexBtn.backgroundColor = UIColorFromRGB(rgbValue: 0x2E2F28)
        flexBtn.setTitle("FLEX", for: .normal)
        flexBtn.setTitleColor(UIColorFromRGB(rgbValue: 0xF61F01), for: .normal)
        flexBtn.addTarget(self, action: #selector(flexAction), for: .touchUpInside)
        flexBtn.sizeToFit()
        flexBtn.width = 50
        flexBtn.top = 44
        flexBtn.left = 0
        view.addSubview(flexBtn)
    }
    
    fileprivate func setupCameraBtn() {
        let cameraBtn = UIButton()
        cameraBtn.backgroundColor = UIColorFromRGB(rgbValue: 0x2E2F28)
        cameraBtn.setTitle("Camera", for: .normal)
        cameraBtn.setTitleColor(UIColorFromRGB(rgbValue: 0x72CE34), for: .normal)
        cameraBtn.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        cameraBtn.sizeToFit()
        cameraBtn.width = 150
        cameraBtn.center = view.center
        view.addSubview(cameraBtn)
    }
    
    @objc fileprivate func flexAction() {
        FLEXManager.shared()?.showExplorer()
    }
    
    @objc fileprivate func cameraAction() {
        AuthenticationHelper.camera {
            AuthenticationHelper.photo {
                dispatch_safe_main_async {
                    let vc = BaseCameraViewController()
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
}
