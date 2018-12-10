//
//  SegmentView.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/12/9.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

fileprivate class SegmentLabel: UILabel {
    fileprivate var redDot: UIView
    fileprivate var isShowRedDot: false {
        set {
            
        }
        get {
            
        }
    }
    
    fileprivate var redDotSize: CGSize {
        if ScreenScale == 2 {
            return CGSize(width: 7, height: 7)
        }
        if ScreenScale == 3 {
            return CGSize(width: 6, height: 5)
        }
        return .zero
    }
    
    override init(frame: CGRect) {
        redDot = UIView()
        super.init(frame: frame)
        
        redDot.size = redDotSize
        redDot.top = top
        redDot.right = right
        redDot.backgroundColor = .red
        redDot.layer.cornerRadius = redDotSize.width/2
        redDot.layer.masksToBounds = true
        redDot.isHidden = true
        addSubview(redDot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        set {
            super.text = text
            guard let text = text else { return }
            let textSize = NSString(string: text).cd_size(with: font)
            redDot.left = width/2 + textSize.width/2 + 1
            redDot.bottom = height/2 + textSize.height/2 - 10
        }
        get {
            return super.text
        }
    }
    

}

class SegmentView: UIView {
    
}
