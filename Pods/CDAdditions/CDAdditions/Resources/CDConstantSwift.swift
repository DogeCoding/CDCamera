//
//  CDConstantSwift.swift
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/13.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import Foundation
import UIKit

// MARK: --- UI ---

func UIColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColorFromRGB(rgbValue: rgbValue, alphaValue: 1)
}

func UIColorFromRGB(rgbValue: Int, alphaValue: Float) -> UIColor {
    return UIColor(red: CGFloat(Float(((rgbValue >> 16) & 0xFF)) / 255.0),
                   green: CGFloat(Float(((rgbValue >> 8) & 0xFF)) / 255.0),
                   blue: CGFloat(Float(((rgbValue >> 0) & 0xFF)) / 255.0),
                   alpha: CGFloat(alphaValue))
}

func RandomColor() -> UIColor {
    return UIColor(hue: CGFloat(arc4random()).truncatingRemainder(dividingBy: 256.0) / 256.0,
                   saturation: CGFloat(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0 + 0.5,
                   brightness: CGFloat(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0 + 0.5,
                   alpha: 1)
}

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenScale = UIScreen.main.scale

// MARK: --- Memory ---

// MARK: --- Multithreading ---
func dispatch_main_async(_ completionHandler: @escaping () -> ()) {
    if Thread.isMainThread {
        completionHandler()
    } else {
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
