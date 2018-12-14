//
//  SegmentView.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/12/9.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

fileprivate class SegmentLabel: UILabel {
    fileprivate var redDot: UIView
    
    fileprivate var isShowRedDot: Bool = false {
        didSet {
            if isShowRedDot {
                redDot.isHidden = false
            } else {
                redDot.isHidden = true
            }
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
        didSet {
            guard let text = oldValue else { return }
            let textSize = NSString(string: text).cd_size(with: font)
            redDot.left = width/2 + textSize.width/2 + 1
            redDot.bottom = height/2 + textSize.height/2 - 10
        }
    }
}

protocol SegmentViewDelegate: NSObjectProtocol {
    func switchTitle(index: Int)
}

class SegmentView: UIView {
    fileprivate var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = false
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    fileprivate var indicateLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 3 / 2
        return layer
    }()
    
    fileprivate var titleArray: Array<String> = []
    fileprivate var labels: Array<SegmentLabel> = []
    fileprivate let kUILabelWidth: Float = 70
    fileprivate let kUILabelHeight: Float = 50
    fileprivate var blankLeft: Float = 0
    
    var currentIndex = 0
    var normalFont: UIFont = UIFont.boldPingFangFont(withSize: 16) {
        didSet {
            for i in 0..<labels.count {
                if currentIndex != i {
                    updateUI(index: i, isSelect: false)
                }
            }
        }
    }
    var selectedFont: UIFont = UIFont.boldPingFangFont(withSize: 15) {
        didSet {
            updateUI(index: currentIndex, isSelect: true)
        }
    }
    var normalFontSize: Float = 12
    var selectedFontSize: Float = 12
    var normalAlpha: Float = 0.6 {
        didSet {
            for i in 0..<labels.count {
                if i == currentIndex {
                    continue
                }
                labels[safe: i]?.textColor = normalTextColor
            }
        }
    }
    var selectedAlpha: Float = 1 {
        didSet {
            labels[safe: currentIndex]?.alpha = selectedAlpha.cgFloat
        }
    }
    var normalTextColor = UIColorFromRGB(rgbValue: 0xffffff, alphaValue: 0.6) {
        didSet {
            for i in 0..<labels.count {
                if i == currentIndex {
                    continue
                }
                labels[safe: i]?.textColor = oldValue
            }
        }
    }
    var selectedTextColor = UIColorFromRGB(rgbValue: 0xffffff, alphaValue: 1) {
        didSet {
            labels[safe: currentIndex]?.textColor = oldValue
        }
    }
    
    weak var delegate: SegmentViewDelegate?
    
    init(titleArray: Array<String>) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
        
        self.titleArray = titleArray
        blankLeft = ScreenWidth.toFloat() / 2 - kUILabelWidth / 2
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(clickTitle(ges:)))
        addGestureRecognizer(singleTap)
        setupUI()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        scrollView.frame = frame
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: (titleArray.count.toFloat() * kUILabelWidth + 2 * blankLeft).toCGFloat(), height: height)
        
        for i in 0..<titleArray.count {
            let label = SegmentLabel(frame: CGRect(x: 0, y: 0, width: kUILabelWidth.toCGFloat(), height: kUILabelHeight.toCGFloat()))
            label.textAlignment = .center
            label.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            label.shadowOffset = CGSize(width: 0.8, height: 1)
            label.top = 0
            label.left = i.toFloat().toCGFloat() * label.width + blankLeft.toCGFloat()
            labels.append(label)
            scrollView.addSubview(label)
            if i == currentIndex {
                updateUI(index: i, isSelect: true)
            } else {
                updateUI(index: i, isSelect: false)
            }
            label.text = titleArray[safe: i]
        }
        indicateLine.frame = CGRect(x: (width - 8) / 2, y: 6.5 + 34, width: 8, height: 3)
        layer.addSublayer(indicateLine)
        
        let point = CGPoint(x: kUILabelWidth.cgFloat * currentIndex.cgFloat, y: 0)
        scrollView.setContentOffset(point, animated: false)
    }
    
    @objc fileprivate func clickTitle(ges: UIGestureRecognizer) {
        guard ges.state == .recognized else { return }
        let point = ges.location(in: scrollView)
        guard point.x > blankLeft.cgFloat else { return }
        
        let titleIndex = floor(point.x - blankLeft.cgFloat).int
        if titleIndex < titleArray.count {
            select(index: titleIndex)
        }
    }
    
    fileprivate func updateUI(index: Int, isSelect: Bool) {
        guard index >= 0 && index < labels.count else { return }
        let label = labels[safe: index]
        label?.font = isSelect ? selectedFont : normalFont
        label?.textColor = isSelect ? selectedTextColor : normalTextColor
    }
    
    fileprivate func select(index: Int) {
        labels[safe: index]?.isShowRedDot = false
        
        let point = CGPoint(x: kUILabelWidth.cgFloat * index.cgFloat, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.contentOffset = point
        }) { (finished) in
            if self.currentIndex != index {
                self.updateUI(index: self.currentIndex, isSelect: false)
                self.currentIndex = index
                self.updateUI(index: self.currentIndex, isSelect: true)
                self.delegate?.switchTitle(index: index)
            }
        }
    }
    
    func showRedDot(index: Int) {
        guard index < labels.count else { return }
        labels[safe: index]?.isShowRedDot = true
    }
    
    func switchIndex(index: Int) {
        guard index < labels.count else { return }
        select(index: index)
    }
}

extension SegmentView: UIScrollViewDelegate {

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offset = scrollView.contentOffset
            let index = round(offset.x / kUILabelWidth.cgFloat).int
            
            select(index: index)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let index = round(offset.x / kUILabelWidth.cgFloat).int
        
        select(index: index)
    }
}
