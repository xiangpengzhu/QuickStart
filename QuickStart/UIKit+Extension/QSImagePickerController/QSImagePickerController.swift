//
//  QSImagePickerController.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/29.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit

@objc public protocol QSImagePickerControllerDelegate: NSObjectProtocol {
	
	/// 选择成功回调
	///
	/// - Parameters:
	///   - imagePicker: imagePicker description
	///   - images: 成功选择的图片
	@objc optional func imagePicker(imagePicker: QSImagePickerController, didFinishedSelectImages images: [UIImage])
}

/// 相册图片多选控件
public class QSImagePickerController: UIViewController {

	
	/// 最大选取数量
	public var maxCount: Int = 10
	
	/// 压缩图片最大宽度
	public var compressImageMaxWidth: CGFloat = 1000
	
	/// 压缩图片最大高度
	public var compressImageMaxHeight: CGFloat = 1000
	
	public weak var delegate: QSImagePickerControllerDelegate?
	
	fileprivate var loadingView: UIView?
	
	override public func viewDidLoad() {
        super.viewDidLoad()
		
		let albumsController = QSImagePickerAlbumsController(withImagePicker: self)
		albumsController.maxCount = maxCount
		albumsController.compressImageMaxWidth = compressImageMaxWidth
		albumsController.compressImageMaxHeight = compressImageMaxHeight
		let navigation = UINavigationController(rootViewController: albumsController)
		addChildViewController(navigation)
		
		view.addSubview(navigation.view)
		navigation.view.frame = self.view.bounds;
		
		navigation.view.translatesAutoresizingMaskIntoConstraints = false;
		
		var constraints = [NSLayoutConstraint]()
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllBottom, metrics: nil, views: ["view": navigation.view]))
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllLeft, metrics: nil, views: ["view": navigation.view]))
		view.addConstraints(constraints)
    }

	deinit {
		print("QSImagePickerController deinit")
	}
}


// MARK: - public functions
extension QSImagePickerController {
	
	public func show(inViewController controller: UIViewController) {
		controller.present(self, animated: true, completion: nil)
	}
	
	public func dismiss(completion: (()->Void)?) {
		self.dismiss(animated: true, completion: completion)
	}
	
	
	
	/// 最后选取图片点击完成时，获取图片的loading
	func startDoneLoading() {
		stopDoneLoading()
		
		let loadingV = UIView(frame: view.bounds)
		
		loadingV.backgroundColor = UIColor(colorHexValue: 0x000000, alpha: 0.6)
		
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		loadingV.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		
		let label = UILabel(color: UIColor.white, font: UIFont.systemFont(ofSize: 14))
		label.text = "读取图片..."
		label.textAlignment = .center
		loadingV.addSubview(label)
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		let activityIndicatorLayouts = [
			NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingV, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingV, attribute: .centerY, multiplier: 1, constant: 0),
		]
		loadingV.addConstraints(activityIndicatorLayouts)
		
		
		let labelLayouts = [
			NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: 10),
			NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: loadingV, attribute: .leading, multiplier: 1, constant: 10),
			NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: loadingV, attribute: .trailing, multiplier: 1, constant: -10),
			NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 20),
		]
		loadingV.addConstraints(labelLayouts)
		
		view.addSubview(loadingV)
		loadingV.translatesAutoresizingMaskIntoConstraints = false
		let loadingVLayouts = [
			NSLayoutConstraint(item: loadingV, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: loadingV, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: loadingV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: loadingV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		]
		view.addConstraints(loadingVLayouts)
		
		self.loadingView = loadingV
	}
	
	func stopDoneLoading() {
		loadingView?.removeFromSuperview()
		loadingView = nil
	}
}


// MARK: - private functions
extension QSImagePickerController {
	
}
