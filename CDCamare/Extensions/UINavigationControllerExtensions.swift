//
//  UINavigationControllerExtensions.swift
//  ZiShu
//
//  Created by CodingDoge on 2018/6/20.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

extension UINavigationController {
    @discardableResult func popToStackViewController(withClassName name: String, animated: Bool) -> UIViewController {
        var vc = UIViewController()
        guard let cls = NSClassFromString(ZSNamespace+"."+name) else {
            return vc
        }
        for tvc in viewControllers {
            if tvc.isKind(of: cls) {
                popToViewController(tvc, animated: animated)
                vc = tvc
                break
            }
        }
        return vc
    }
}
