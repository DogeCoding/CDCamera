//
//  BaseNavigationViewController.swift.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class BaseNavigationViewController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isNavigationBarHidden = true
        pushViewController(RootViewController.shared, animated: false)
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
        
        delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            return true
        }
        return false
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let recognizer = interactivePopGestureRecognizer, !recognizer.isEnabled{
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    
}
