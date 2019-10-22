//
//  HomeBottomPanel.swift
//  CDCamare
//
//  Created by yangfukai on 2019/10/18.
//  Copyright © 2019 杨扶恺. All rights reserved.
//

import Foundation

@objc protocol HomeBottomPanelDelegate: NSObjectProtocol {
	@objc func panelStartRecord(panel: HomeBottomPanel, isLongPress: Bool)
	@objc func panelPauseRecord(panel: HomeBottomPanel)
	@objc func panelFinishRecord(panel: HomeBottomPanel)
}

class HomeBottomPanel: UIView {
	fileprivate var minDuration: CGFloat
	fileprivate var maxDuration: CGFloat
	fileprivate var isRecording: Bool = false
	
	fileprivate var shootButton: HomeShootButton?
	
	var currentDuration: CGFloat = 0
	
	weak var delegate: HomeBottomPanelDelegate?
	
	init(frame: CGRect, minDuration: CGFloat, maxDuration: CGFloat) {
		self.minDuration = minDuration
		self.maxDuration = maxDuration
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupUI() {
		let center = CGPoint(x: width / 2, y: height / 2 - safeAreaInsets.bottom)
		
		shootButton = HomeShootButton(center: center)
		shootButton?.minDuration = minDuration
		shootButton?.maxDuration = maxDuration
		shootButton?.minProcess = minDuration / maxDuration
		let singleClick = UITapGestureRecognizer(target: self, action: #selector(captureHandler(recognizer:)))
		let longTap = UILongPressGestureRecognizer(target: self, action: #selector(captureHandler(recognizer:)))
		shootButton?.addGestureRecognizer(singleClick)
		shootButton?.addGestureRecognizer(longTap)
		
		addSubview(shootButton!)
	}
	
	fileprivate func startRecord(_ isLongPress: Bool) {
		startAnimation()
		delegate?.panelStartRecord(panel: self, isLongPress: isLongPress)
	}
	
	fileprivate func pauseRecord() {
		pauseAnimation()
		delegate?.panelPauseRecord(panel: self)
	}
	
	fileprivate func finishRecord() {
		delegate?.panelFinishRecord(panel: self)
	}
	
	@objc fileprivate func captureHandler(recognizer: UIGestureRecognizer) {
		if recognizer is UITapGestureRecognizer {
			if isRecording {
				pauseRecord()
			} else {
				startRecord(false)
			}
		} else if recognizer is UILongPressGestureRecognizer {
			if recognizer.state == .began && !isRecording {
				startRecord(true)
			} else if (recognizer.state == .ended || recognizer.state == .cancelled) && isRecording {
				pauseRecord()
			}
		}
	}
	
	// MARK: - Public
	func startAnimation() {
		if currentDuration == 0 {
			shootButton?.startAnimation()
		} else {
			shootButton?.resumeAnimation()
		}
	}
	
	func pauseAnimation() {
		if currentDuration >= maxDuration {
			currentDuration = maxDuration
			shootButton?.pause(process: 1.0)
		} else {
			shootButton?.pause(process: currentDuration / (maxDuration > 0 ? maxDuration : currentDuration))
		}
	}
}
