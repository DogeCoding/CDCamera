//
//  UIColorExtensions.swift
//  ZiShu
//
//  Created by 宋 奎熹 on 2018/5/23.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var mainOrange: UIColor = {
        return UIColorFromRGB(0xFD930A)
    }()
    
    static var mainGreen: UIColor = {
        return UIColorFromRGB(0x5DD46A)
    }()
    
    static var mainBlue: UIColor = {
        return UIColorFromRGB(0x6189C9)
    }()
    
    static var zs_gray: UIColor = {
        return UIColorFromRGB(0xC8C8C8)
    }()
    
    static var zs_lightGray: UIColor = {
        return UIColorFromRGB(0xF5F5F5)
    }()
    
    static var secondGreen: UIColor = {
        return UIColor(red: 53.0/255.0, green: 213.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    }()
    
    static var darkBlueColor: UIColor = {
        return UIColor(red: 70.0/255.0, green: 102.0/255.0, blue: 118.0/255.0, alpha: 1.0)
    }()
    
    static var lightBlueColor: UIColor = {
        return UIColor(red: 70.0/255.0, green: 165.0/255.0, blue: 196.0/255.0, alpha: 1.0)
    }()
    
    class func zs_redColorFrom(hexRGBColor color: NSInteger) -> CGFloat {
        return (CGFloat((color & 0xff0000) >> 16) / 255.0)
    }
    
    class func zs_greenColorFrom(hexRGBColor color: NSInteger) -> CGFloat {
        return (CGFloat((color & 0x00ff00) >> 8) / 255.0)
    }
    
    class func zs_blueColorFrom(hexRGBColor color: NSInteger) -> CGFloat {
        return (CGFloat(color & 0x0000ff) / 255.0)
    }
    
    class func zs_colorWith(hexValue value: NSInteger) -> UIColor {
        return UIColor.zs_colorWith(hexValue: value, alpha: 1)
    }
    
    class func zs_colorWith(hexValue value: NSInteger, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: UIColor.zs_redColorFrom(hexRGBColor: value),
                            green: UIColor.zs_greenColorFrom(hexRGBColor: value),
                            blue: UIColor.zs_blueColorFrom(hexRGBColor: value),
                            alpha: alpha)
    }
    
    class func zs_randomColorWith(alpha: CGFloat) -> UIColor {
        return UIColor.init(hue: CGFloat(arc4random() % 256 / 256),
                            saturation: CGFloat(arc4random() % 128 / 256) + 0.5,
                            brightness: CGFloat(arc4random() % 128 / 256) + 0.5,
                            alpha: alpha)
    }
    
    class func zs_randomColor() -> UIColor {
        return UIColor.zs_randomColorWith(alpha: 1)
    }
}
