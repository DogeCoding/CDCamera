//
//  HomeTopSupportView.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

protocol HomeTopSupportViewDelegate: NSObjectProtocol {
    func clickDelayCapture()
    
    func clickTorch()
    
    func clickGrid()
    
    func clickCameraSetting()
}

fileprivate let btnWidth: CGFloat = 45

class HomeTopSupportView: UIView {
    
    weak var delegate: HomeTopSupportViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColorFromRGB(rgbValue: 0x2E2F28, alphaValue: 0.5)
        addSubview(createButton(withImageName: "camera_switch", title: "延时拍摄", selector: #selector(delayCaptureAction)))
        addSubview(createButton(withImageName: "camera_switch", title: "闪光灯", selector: #selector(torchAction)))
        addSubview(createButton(withImageName: "camera_switch", title: "网格线", selector: #selector(gridAction)))
        addSubview(createButton(withImageName: "camera_switch", title: "相机设置", selector: #selector(cameraSettingAction)))
        updateFrame()
    }
    
    fileprivate func createButton(withImageName name: String, title: String, selector: Selector) -> BaseButton {
        let btn = BaseButton.button(CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth+10), target: self, action: selector, info: ["normal_title":title, "normal_img":name], defaulutPressed: false)
        btn.imageCustomFrame = CGRect(x: 5, y: 3, width: btnWidth-10, height: btnWidth-10)
        btn.titleCustomFrame = CGRect(x: 0, y: 3 + btnWidth - 10 + 3, width: btnWidth, height: 10+btnWidth - (3 + btnWidth - 10 + 3))
        return btn
    }
    
    func updateFrame() {
        let padding: CGFloat = 15
        let gap: CGFloat = (width - 2 * padding - btnWidth * CGFloat(subviews.count)) / (CGFloat(subviews.count) - 1)
        var rect: CGRect = CGRect(x: padding, y: (height - btnWidth)/2, width: btnWidth, height: btnWidth)
        for view in subviews {
            view.origin.x = rect.origin.x
            view.origin.y = rect.origin.y
            rect.origin.x += gap + btnWidth
        }
    }
    
    @objc fileprivate func delayCaptureAction() {
        delegate?.clickDelayCapture()
    }
    
    @objc fileprivate func torchAction() {
        delegate?.clickTorch()
    }
    
    @objc fileprivate func gridAction() {
        delegate?.clickGrid()
    }
    
    @objc fileprivate func cameraSettingAction() {
        delegate?.clickCameraSetting()
    }
    
    func show() {
        alpha = 0
        let originalWidth = width
        width = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.width = originalWidth
        }) { (finish) in
            
        }
    }
    
    func dismiss(_ completionHandler: (() -> ())?) {
        alpha = 1
        let originalWidth = width
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.width = 0
        }) { (finish) in
            self.alpha = 1
            self.width = originalWidth
            completionHandler?()
        }
    }
}
