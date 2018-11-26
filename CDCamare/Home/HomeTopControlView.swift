//
//  HomeTopControlView.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/25.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

protocol HomeTopControlViewDelegate: NSObjectProtocol {
    func switchCamera(isFront: Bool)
    
    func switchTorch(isOff: Bool)
    
    func switchGrid(isShow: Bool)
    
    func switchDelayCapture(isDelay: Bool)
}

class HomeTopControlView: UIView {
    
}
