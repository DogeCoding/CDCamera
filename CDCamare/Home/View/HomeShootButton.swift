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
	
	var process: CGFloat?
	var minProcess: CGFloat?
	var pauseAngles: Array<CGFloat>?
	var minDuration: Float?
	var maxDuration: Float?
	
	fileprivate var innerCircle: UIView?
	fileprivate var minorPoint: UIView?
	
	init(center: CGPoint) {
		let width = kNormalRadius + kLineWidth / 2
		super.init(frame: CGRect(x: center.x - width, y: center.y - width, width: width * 2, height: width * 2))
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
