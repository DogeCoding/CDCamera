//
//  BaseButton.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/23.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class BaseButton: UIButton {
    
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
    }
}
