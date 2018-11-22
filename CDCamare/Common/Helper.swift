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