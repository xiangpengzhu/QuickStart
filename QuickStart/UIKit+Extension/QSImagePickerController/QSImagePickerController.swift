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
	@objc optional func imagePicker(imagePicker: QSImagePickerController, didFinishedSelectImages images: UIImage)
}

/// 相册图片多选控件
public class QSImagePickerController: UIViewController {

	
	/// 最大选取数量
	public var maxCount: Int = 0
	
	/// 压缩图片最大宽度
	public var compressImageMaxWidth: CGFloat = 0
	
	/// 压缩图片最大高度
	public var compressImageMaxHeight: CGFloat = 0
	
	/// 压缩图片质量
	public var compressImageQuality: Float = 0
	
	public weak var delegate: QSImagePickerControllerDelegate?
	
	override public func viewDidLoad() {
        super.viewDidLoad()
		
		let albumsController = QSImagePickerAlbumsController(withImagePicker: self)
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
}


// MARK: - private functions
extension QSImagePickerController {
	
}
