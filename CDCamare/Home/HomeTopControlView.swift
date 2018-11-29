//
//  HomeTopControlView.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/25.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

protocol HomeTopControlViewDelegate: NSObjectProtocol {
    func clickMore(isOpen: Bool)

    func clickRatio(width: CGFloat, heigth: CGFloat)
    
    func clickAlbum()
    
    func clickSwitchCamera()
}

fileprivate let btnWidth: CGFloat = 45

class HomeTopControlView: UIView {
    
    weak var delegate: HomeTopControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(createButton(withImageName: "camera_switch", selector: #selector(moreAction)))
        addSubview(createButton(withImageName: "camera_switch", selector: #selector(ratioAction)))
        addSubview(createButton(withImageName: "camera_switch", selector: #selector(albumAction)))
        addSubview(createButton(withImageName: "camera_switch", selector: #selector(switchCameraAction)))
        updateFrame()
    }
    
    fileprivate func createButton(withImageName name: String, selector: Selector) -> BaseButton {
        let btn = BaseButton(type: .custom)
        btn.setImage(UIImage(named: name), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.size = CGSize(width: btnWidth, height: btnWidth)
        return btn
    }
    
    func updateFrame() {
        let padding: CGFloat = 15
        let gap: CGFloat = (width - 2 * padding - btnWidth * CGFloat(subviews.count)) / (CGFloat(subviews.count) - 1)
        var rect: CGRect = CGRect(x: padding, y: (height - btnWidth)/2, width: btnWidth, height: btnWidth)
        for view in subviews {
            view.frame = rect
            rect.origin.x += gap + btnWidth
        }
    }
    
    @objc fileprivate func moreAction() {
        delegate?.clickMore(isOpen: true)
    }
    fileprivate var ratioIndex = 0
    @objc fileprivate func ratioAction() {
        var width: CGFloat = 720
        var height: CGFloat = 1280
        ratioIndex = (ratioIndex+1)%2
        
        switch ratioIndex {
        case 0:
            width = 720
            height = 1280
        case 1:
            width = 480
            height = 640
        case 2:
            width = 1
            height = 1
        default:
            break
        }
        
        delegate?.clickRatio(width: width, heigth: height)
    }
    
    @objc fileprivate func albumAction() {
        delegate?.clickAlbum()
    }
    
    @objc fileprivate func switchCameraAction() {
        delegate?.clickSwitchCamera()
    }
}
