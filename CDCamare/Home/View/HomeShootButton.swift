//
//  HomeShootButton.swift
//  CDCamare
//
//  Created by yangfukai on 2019/9/19.
//  Copyright © 2019 杨扶恺. All rights reserved.
//

import Foundation

class HomeShootButton: UIView {
	let kNormalRadius: CGFloat = 34
	let kRecordRadius: CGFloat = 50
	fileprivate var kScaleValue: CGFloat {
		kNormalRadius / kRecordRadius
	}
	fileprivate let kLineWidth: CGFloat = 7
	
    private var p_process: CGFloat = 0
    var process: CGFloat {
        get {
            return p_process
        }
        set {
            if p_process == newValue {
                return
            }
            p_process = newValue
        }
    }
	var minProcess: CGFloat?
	var pauseAngles: Array<CGFloat>?
	var minDuration: Float?
	var maxDuration: Float?
	
    fileprivate var innerCircle: UIView {
        let circle = UIView()
        circle.backgroundColor = .white
        circle.layer.masksToBounds = true
        return circle
    }
    
    fileprivate var pauseSupportLayer: CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }
    
    fileprivate var pauseIndicateLayer: CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.opacity = 0
        layer.masksToBounds = true
        return layer
    }
    
    fileprivate var minorPoint: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(displayP3Red: 11/255, green: 1, blue: 0, alpha: 1)
        return view
    }
	
	init(center: CGPoint) {
		let width = kNormalRadius + kLineWidth / 2
		super.init(frame: CGRect(x: center.x - width, y: center.y - width, width: width * 2, height: width * 2))
		
        
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func setupUI() {
        innerCircle.size = CGSize(width: kRecordRadius, height: kRecordRadius)
        innerCircle.layer.cornerRadius = innerCircle.width / 2
        
        pauseSupportLayer.frame = CGRect(x: kNormalRadius - 1, y: -1, width: 2, height: kNormalRadius * 2 + 2)
        pauseSupportLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pauseSupportLayer.isHidden = true
        
        pauseIndicateLayer.frame = CGRect(x: 0, y: 0, width: 2, height: kLineWidth * kScaleValue + 1)
        pauseIndicateLayer.cornerRadius = 0.5
        pauseSupportLayer.addSublayer(pauseIndicateLayer)
    }
}
