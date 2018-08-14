//
//  UIViewControllerExtensions.swift
//  ZiShu
//
//  Created by 宋 奎熹 on 2018/5/23.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func push(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(vc: UIViewController, completion: (() -> Void)? = nil) {
        self.present(vc, animated: true, completion: completion)
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
    
}

protocol NibLoadable {
    
}

extension UIViewController: NibLoadable {
    
//    static func loadFromNib() -> self {
//        
//    }
    
}
