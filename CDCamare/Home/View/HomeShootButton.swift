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
			
			setNeedsDisplay()
			
			if newValue == 0 {
				minorPoint.isHidden = true
			} else if minorPoint.isHidden && newValue > 0.001 {
				minorPoint.isHidden = false
			}
        }
    }
	
	private var p_minProcess:CGFloat = 0
	var minProcess: CGFloat {
		get {
			return p_minProcess
		}
		set {
			if p_minProcess == newValue {
				return
			}
			p_minProcess = newValue
			minorPoint.center = minorPointCenter()
		}
	}
	
	var pauseAngles: Array<CGFloat>?
	var minDuration: CGFloat = 3
	var maxDuration: CGFloat = 15
	
    fileprivate var innerCircle: UIView {
        let circle = UIView()
        circle.backgroundColor = .red
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
		
        setupUI()
		minProcess = 0.2
		minorPoint.center = minorPointCenter()
		minorPoint.isHidden = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    fileprivate func setupUI() {
		backgroundColor = .clear
		
        innerCircle.size = CGSize(width: kRecordRadius, height: kRecordRadius)
        innerCircle.layer.cornerRadius = innerCircle.width / 2
		addSubview(innerCircle)
        
        pauseSupportLayer.frame = CGRect(x: kNormalRadius - 1, y: -1, width: 2, height: kNormalRadius * 2 + 2)
        pauseSupportLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pauseSupportLayer.isHidden = true
		layer.addSublayer(pauseSupportLayer)
        
        pauseIndicateLayer.frame = CGRect(x: 0, y: 0, width: 2, height: kLineWidth * kScaleValue + 1)
        pauseIndicateLayer.cornerRadius = 0.5
        pauseSupportLayer.addSublayer(pauseIndicateLayer)
    }
	
	fileprivate func minorPointCenter() -> CGPoint {
		let width = kNormalRadius
		let lineWidth = kLineWidth
		let radius = width - lineWidth / 2
		let angle = minProcess * 2 * CGFloat.pi
		let centerX = width + CGFloat(sinf(Float(angle))) * radius
		let centerY = width - CGFloat(cosf(Float(angle))) * radius
		return CGPoint(x: centerX, y: centerY)
	}
	
	override func draw(_ rect: CGRect) {
		let ctx = UIGraphicsGetCurrentContext()
		let width = kNormalRadius
		let lineWidth = kLineWidth
		let center = CGPoint(x: width + lineWidth / 2, y: width + lineWidth / 2)
		let radius = width - lineWidth / 2
		let startA = -CGFloat.pi / 2
		let endA = startA + CGFloat.pi * 2 * process
		
		// 半透明圆环
		let pathCircle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		pathCircle.lineWidth = lineWidth
		UIColorFromRGB(rgbValue: 0xffffff, alphaValue: 0.2).setStroke()
		pathCircle.stroke()
		
		// 绿色圆环进度条
		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
		path.lineWidth = lineWidth
		UIColorFromRGB(rgbValue: 0x16e05a, alphaValue: 1).setStroke()
		path.stroke()
		
		// 暂停的白细条
		if let pauseAngles = pauseAngles, pauseAngles.count > 0 {
			for angle in pauseAngles {
				let widthP: CGFloat = 4 / 360
				let startP = CGFloat.pi * 2 * (angle - widthP) + startA
				let endP = startP + (CGFloat.pi * 2 * widthP)
				let pathP = UIBezierPath(arcCenter: center, radius: radius, startAngle: startP, endAngle: endP, clockwise: true)
				UIColor.white.setStroke()
				pathP.lineWidth = lineWidth
				pathP.stroke()
			}
		}
		
		// 最小时间的绿细条
		if process > 0.001 && process < minProcess {
			let widthP: CGFloat = 2 / 360
			let startP = CGFloat.pi * 2 * (minProcess - widthP) + startA
			let endP = startP + (CGFloat.pi * 2 * widthP)
			let pathP = UIBezierPath(arcCenter: center, radius: radius, startAngle: startP, endAngle: endP, clockwise: true)
			UIColorFromRGB(rgbValue: 0x16e05a, alphaValue: 1).setStroke()
			pathP.lineWidth = lineWidth
			pathP.stroke()
		}
		ctx?.strokePath()
	}
	
	func resetStatus() {
		pause(process: 0)
		pauseAngles?.removeAll()
		pauseSupportLayer.transform = CATransform3DIdentity
		pauseSupportLayer.isHidden = true
	}
	
	func pause(process: CGFloat) {
		if pauseAngles == nil {
			pauseAngles = Array()
		}
		self.process = process
		pauseAngles!.append(process)
		
		UIView.animate(withDuration: 0.2, animations: {
			self.innerCircle2SquareAnimation(bool: false)
			self.transform = .identity
		}) { (finished) in
			self.pauseIndicateAnimation()
		}
	}
	
	fileprivate func innerCircle2SquareAnimation(bool: Bool, _ duration: CGFloat = 0.2) {
		let squareWidth: CGFloat = 41
		let groupAnimation = CAAnimationGroup()
		let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
		cornerAnimation.toValue = NSNumber(value: bool ? 5 : kRecordRadius.float / 2)
		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
		scaleAnimation.toValue = NSNumber(value: bool ? (squareWidth * kScaleValue / kRecordRadius).float : 1)
		
		groupAnimation.animations = [cornerAnimation, scaleAnimation]
		groupAnimation.duration = Double(duration)
		groupAnimation.isRemovedOnCompletion = false
		groupAnimation.fillMode = kCAFillModeForwards
		innerCircle.layer.add(groupAnimation, forKey: nil)
	}
	
	fileprivate func pauseIndicateAnimation() {
		guard let pauseAngles = pauseAngles, pauseAngles.count > 0, process != 1 else {
			pauseIndicateLayer.removeAllAnimations()
			pauseSupportLayer.isHidden = true
			return
		}
		
		if process == 0 {
			pauseSupportLayer.isHidden = true
			return
		} else if pauseSupportLayer.isHidden {
			pauseSupportLayer.isHidden = false
		}
		pauseSupportLayer.transform = CATransform3DMakeRotation(pauseAngles.last! * 2 * CGFloat.pi, 0, 0, 1)
		let groupAnimation = CAAnimationGroup()
		let cornerAniamtion = CABasicAnimation(keyPath: "opacity")
		cornerAniamtion.toValue = NSNumber(value: 1)
		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
		scaleAnimation.toValue = NSNumber(value: 1.15)
		
		groupAnimation.animations = [cornerAniamtion, scaleAnimation]
		groupAnimation.duration = 0.7
		groupAnimation.repeatCount = MAXFLOAT
		groupAnimation.isRemovedOnCompletion = false
		groupAnimation.fillMode = kCAFillModeForwards
		pauseIndicateLayer.add(groupAnimation, forKey: nil)
	}
	
	func startAnimation() {
		process = 0
		pauseAngles?.removeAll()
		resumeAnimation()
	}
	
	func resumeAnimation() {
		pauseSupportLayer.isHidden = true
		pauseIndicateLayer.removeAllAnimations()
		UIView.animate(withDuration: 0.2, animations: {
			self.innerCircle2SquareAnimation(bool: true)
			self.transform = CGAffineTransform(scaleX: 1 / self.kScaleValue, y: 1 / self.kScaleValue)
		})
	}
	
}
