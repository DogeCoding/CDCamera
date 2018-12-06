//
//  HomeCameraViewController.swift
//  CDCamare
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import TZImagePickerController

class HomeCameraViewController: BaseCameraViewController {
    
    fileprivate var switchCameraBtn: BaseButton?
    fileprivate var captureBtn: BaseButton?
    fileprivate lazy var imageView = UIImageView()
    
    fileprivate var topControlView: HomeTopControlView?
    fileprivate var topSupportView: HomeTopSupportView?
    
    fileprivate var filterNames: [String] = {
        return ["CIColorInvert", "CIPhotoEffectMono", "CIPhotoEffectInstant", "CIPhotoEffectTransfer"]
    }()
    
    fileprivate var focusView: UIView = {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        view.layer.borderColor = UIColorFromRGB(rgbValue: 0xF61F01, alphaValue: 0.8).cgColor
        view.layer.borderWidth = 1
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonUI()
        setupTopControl()
        setupBottomControl()
    }
    
    fileprivate func setupCommonUI() {
        view.backgroundColor = .white
        
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        view.addSubview(imageView)
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapGesture))
        imageView.addGestureRecognizer(imageViewTap)
        
        let previewTap = UITapGestureRecognizer(target: self, action: #selector(previewTapGesture(gesture:)))
        previewTap.require(toFail: imageViewTap)
        view.addGestureRecognizer(previewTap)
        
        view.addSubview(focusView)
    }
    
    fileprivate func setupTopControl() {
        topControlView = HomeTopControlView(frame: CGRect(x: 0, y: 20, width: view.width, height: 50))
        topControlView?.delegate = self
        view.addSubview(topControlView!)
        
        topSupportView = HomeTopSupportView(frame: CGRect(x: 10, y: topControlView!.bottom+10, width: view.width-20, height: 45))
        topSupportView?.delegate = self
        topSupportView?.isHidden = true
        view.addSubview(topSupportView!)
    }
    
    fileprivate func setupRightControl() {
        
    }
    
    fileprivate func setupBottomControl() {
        captureBtn = BaseButton(type: .custom)
        captureBtn?.setImage(UIImage(named: "camera_switch"), for: .normal)
        captureBtn?.size = CGSize(width: 50, height: 50)
        captureBtn?.bottom = view.height - 10
        captureBtn?.centerX = view.centerX
        captureBtn?.addTarget(self, action: #selector(record), for: .touchUpInside)
        view.addSubview(captureBtn!)
    }
    
    override func capturedImageHandler() {
        guard let capturedImage = capturedImage else { return }
        imageView.image = capturedImage
        imageView.isHidden = false
        imageView.isUserInteractionEnabled = true
        view.bringSubview(toFront: imageView)
    }
    
    // MARK: --- Actions ---
    @objc fileprivate func imageViewTapGesture() {
        imageView.isHidden = true
    }
    
    @objc fileprivate func previewTapGesture(gesture: UITapGestureRecognizer) {
        if let topSupportView = topSupportView, !topSupportView.isHidden {
            topSupportView.dismiss {
                topSupportView.isHidden = true
            }
            return
        }
        guard let previewLayer = previewVideoLayer else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: focusView)
        let location = gesture.location(in: view)
        let convertdLocation = previewLayer.convert(location, from: previewLayer.superlayer)
        focusView.center = convertdLocation
        focusView.alpha = 0
        focusView.isHidden = false
        touch(withPoint: location, num: 2)
        UIView.animate(withDuration: 0.2, animations: {
            self.focusView.alpha = 1
        }) { (finish) in
            self.focusView.isHidden = true
        }
    }
}

extension HomeCameraViewController: HomeTopControlViewDelegate {
    func clickMore(isOpen: Bool) {
        guard let topSupportView = topSupportView else { return }
        if !topSupportView.isHidden {
            topSupportView.dismiss {
                topSupportView.isHidden = true
            }
            return
        }
        topSupportView.isHidden = false
        topSupportView.show()
    }
    
    func clickRatio(width: CGFloat, heigth: CGFloat) {
        changePreset(width: width, height: heigth)
    }
    
    func clickAlbum() {
        guard let imagePickVC = TZImagePickerController(maxImagesCount: 1, delegate: self) else { return }
        present(imagePickVC, animated: false, completion: nil)
    }
    
    func clickSwitchCamera() {
        switchCamera(withAnimate: false)
    }
}

fileprivate var filterIndex: Int = 0
extension HomeCameraViewController: HomeTopSupportViewDelegate {
    func clickDelayCapture() {
        
        let filterName = filterNames[filterIndex % filterNames.count]
        filterIndex += 1
        filter = CIFilter(name: filterName)
    }
    
    func clickTorch() {
        isTorchOn = !isTorchOn
    }
    
    func clickGrid() {
        guard let gridLayer = gridLayer else { return }
        gridLayer.isHidden = !gridLayer.isHidden
    }
    
    func clickCameraSetting() {
        
    }
}

extension HomeCameraViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        
    }
}
