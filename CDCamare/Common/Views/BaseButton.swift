//
//  BaseButton.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/23.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import Kingfisher

class BaseButton: UIButton {
    
    class func button(_ frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50), target: AnyObject, action: Selector, info: Dictionary<String, String>, defaulutPressed: Bool) -> BaseButton {
        let button = BaseButton(frame: frame)
        
        button.onImageName = info[safe: "f"]
        
        return button
    }
    
    var imageCustomFrame: CGRect = .zero
    var imageCustomInsets: UIEdgeInsets = .zero {
        didSet {
            imageCustomFrame = CGRect(x: oldValue.left, y: oldValue.top,
                                      width: width - oldValue.left - oldValue.right,
                                      height: height - oldValue.top - oldValue.bottom)
            
        }
    }
    
    fileprivate var hasManualTitleCustomFrmae: Bool = false
    var titleCustomFrame: CGRect = .zero {
        didSet {
            hasManualTitleCustomFrmae = true
        }
    }
    var titleCustomInsets: UIEdgeInsets = .zero {
        didSet {
            titleCustomFrame = CGRect(x: oldValue.left, y: oldValue.top,
                                      width: width - oldValue.left - oldValue.right,
                                      height: height - oldValue.top - oldValue.bottom)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageCustomInsets != .zero {
            imageView?.frame = imageCustomFrame
        }
        if titleCustomInsets != .zero {
            titleLabel?.frame = titleCustomFrame
        }
        if hasManualTitleCustomFrmae {
            titleLabel?.frame = titleCustomFrame
        }
    }
    
    func roundImage() {
        cd_applyCornerborder(height/2, byRoundingCorners: .allCorners, borderWidth: 0, borderColor: .clear)
    }
    
    var normalTitle : String = ""
    var offTitle    : String = ""
    var onTitle     : String = ""
    
    var normalImageName : String = ""
    var offImageName    : String = ""
    var onImageName     : String = ""
    
    fileprivate weak var activeTarget: AnyObject?
    fileprivate var activeSelector: Selector?
    
    fileprivate var isPressed = false
    fileprivate func buttonClickAction(sender: Any) {
        isPressed = !isPressed
        
        if isPressed {
            if offImageName.count > 0 {
                setImage(UIImage(named: offImageName), for: .normal)
            }
            if offTitle.count > 0 {
                setTitle(offTitle, for: .normal)
            }
        } else {
            if onImageName.count > 0 {
                setImage(UIImage(named: onImageName), for: .normal)
            }
            if onTitle.count > 0 {
                setTitle(onTitle, for: .normal)
            }
        }
        
        guard let activeTarget = activeTarget, let activeSelector = activeSelector else { return }
        
        _ = activeTarget.perform(activeSelector, with: sender)
    }
}
