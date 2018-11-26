//
//  BaseButton.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/23.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

class BaseButton: UIButton {
    
    func verticalButton(vPadding: CGFloat) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        contentVerticalAlignment = .top
        contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsetsMake((height - vPadding - imageView.height - titleLabel.height)/2, (width - imageView.width)/2, 0, 0)
        titleEdgeInsets = UIEdgeInsetsMake(imageView.bottom+vPadding, (width - titleLabel.width)/2, 0, 0)
    }
    
}
