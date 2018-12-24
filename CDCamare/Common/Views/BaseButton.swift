//
//  BaseButton.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/23.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class BaseButton: UIButton {
    
    func verticalButton(vPadding: CGFloat) {
        guard let imageView = imageView, let titleLabel = titleLabel, let titleText = titleLabel.text else { return }
        contentVerticalAlignment = .top
        contentHorizontalAlignment = .left
        let iconWidth = width-10
        imageView.size = CGSize(width: iconWidth, height: iconWidth)
        let labelWidth = NSString(string: titleText).cd_size(with: titleLabel.font).width
        imageEdgeInsets = UIEdgeInsetsMake((width - iconWidth)/2 - vPadding, (width - iconWidth)/2, 0, 0)
        titleEdgeInsets = UIEdgeInsetsMake((width + iconWidth)/2 - vPadding, (width - labelWidth)/2 - iconWidth, 0, 0)
    }
    
    var imageCustomFrame: CGRect = .zero
    
    var imageCustomInsets: UIEdgeInsets = .zero {
        didSet {
            
        }
    }
    
}
