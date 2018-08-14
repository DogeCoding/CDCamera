//
//  UIFontExtensions.swift
//  ZiShu
//
//  Created by CodingDoge on 2018/6/12.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

extension UIFont {
    class func zs_fontWith(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        if let font = font {
            return font;
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    class func zs_defaultFontWith(size: CGFloat) -> UIFont {
        return UIFont.zs_fontWith(name: "PingFangSC-Semibold", size: size)
    }
}
