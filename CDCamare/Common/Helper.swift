//
//  Helper.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/21.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

enum CDNotification: String {
    case userLogout
    case userLogin
    
    var stringValue: String {
        return "CP" + rawValue
    }
    
    var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}

extension NotificationCenter {
    static func post(customeNotification name: CDNotification, object: Any? = nil) {
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
}

func touchShake() {
    if #available(iOS 9.0, *) {
        if UIScreen.main.traitCollection.forceTouchCapability == .available {
            AudioServicesPlaySystemSound(1519)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

extension CGFloat {
    func toFloat() -> Float {
        return Float(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var int: Int {
        return Int(self)
    }
}

extension Float {
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var int: Int {
        return Int(self)
    }
}

extension Int {
    func toFloat() -> Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var float: Float {
        return Float(self)
    }
}

extension Double {
    var float: Float {
        return Float(self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}

extension Dictionary where Value == Optional<String> {
    subscript (safe key: Key) -> Value {
        return self[key] ?? ""
    }
    
    func stringForKey(key: String) -> String {
        let ans = key
        return ans
    }
}

extension Dictionary where Value == String {
    subscript (safe key: Key) -> Value {
        return self[key] ?? ""
    }
}
