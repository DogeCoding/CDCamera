//
//  AuthenticationHelper.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import AVFoundation
import AssetsLibrary
import Photos

class AuthenticationHelper {
    
    static func camera(_ completion: @escaping () -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                completion()
            } else {
                dispatch_safe_main_async {
                    if let alertVC = UIAlertController.alert(withTitle: "未能获取到相机权限", message: "您未允许’CDCamera’访问您的照片，请在’设置-隐私-照片’中更改设置", cancelTitle: "取消", cancelHandle: nil, otherTitle: "知道了", otherHandle: { (action) in
                        UIApplication.shared.openScheme(UIApplicationOpenSettingsURLString)
                    }) {
                        RootViewController.shared.navigationController?.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    static func photo(_ completion: @escaping () -> ()) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                completion()
            } else {
                dispatch_safe_main_async {
                    if let alertVC = UIAlertController.alert(withTitle: "未能获取到相机权限", message: "您未允许’CDCamera’访问您的照片，请在’设置-隐私-照片’中更改设置", cancelTitle: "取消", cancelHandle: nil, otherTitle: "知道了", otherHandle: { (action) in
                        UIApplication.shared.openScheme(UIApplicationOpenSettingsURLString)
                    }) {
                        RootViewController.shared.navigationController?.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
