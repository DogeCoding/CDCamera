//
//  MacroFile.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

public let RootNavigation = RootViewController.shared.navigationController

// MARK: - UI
public func UIColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColorFromRGB(rgbValue: rgbValue, alphaValue: 1)
}

public func UIColorFromRGB(rgbValue: Int, alphaValue: Float) -> UIColor {
    return UIColor(red: CGFloat(Float(((rgbValue >> 16) & 0xFF)) / 255.0),
                   green: CGFloat(Float(((rgbValue >> 8) & 0xFF)) / 255.0),
                   blue: CGFloat(Float(((rgbValue >> 0) & 0xFF)) / 255.0),
                   alpha: CGFloat(alphaValue))
}

public func RandomColor() -> UIColor {
    return UIColor(hue: CGFloat(arc4random()).truncatingRemainder(dividingBy: 256.0) / 256.0,
                   saturation: CGFloat(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0 + 0.5,
                   brightness: CGFloat(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0 + 0.5,
                   alpha: 1)
}

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height
public let ScreenScale = UIScreen.main.scale
public let Windows = UIApplication.shared.windows
public let NavigationBarHeight: CGFloat = 44
public let TabbarHeight: CGFloat = 49



// MARK: - Memory

// MARK: - Multithreading
public func dispatch_safe_main_async(_ completionHandler: @escaping () -> ()) {
    if Thread.isMainThread {
        completionHandler()
    } else {
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}

public func OnMainThreadAsync(_ completionHandler: @escaping () -> ()) {
    if Thread.isMainThread {
        completionHandler()
    } else {
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}

// MARK: - Tool
public func StringToCGFloat(_ string: String) -> CGFloat {
    let ans = NSString(string: string)
    return CGFloat(ans.floatValue)
}

public let DeviceUUID = NSUUID().uuidString

private var p_isiPhoneXSeries: Bool = false
public var IsiPhoneXSeries: Bool {
	DispatchQueue.once {
		p_isiPhoneXSeries = CGFloat.maximum(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 896.0 ||  CGFloat.maximum(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 812.0
	}
	return p_isiPhoneXSeries
}
public let CurrentSystemVersion: CGFloat = StringToCGFloat(UIDevice.current.systemVersion)
public let MyNamespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
