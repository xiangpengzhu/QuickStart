//
//  QSImagePickerPhotosToolBar.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit

class QSImagePickerPhotosToolBar: UIToolbar {
	
	var count: Int = 0 {
		didSet {
			titleL.text = "已经选择\(count)张图片"
			titleL.sizeToFit()
		}
	}
	
	var doneDisable: Bool = true {
		didSet {
			doneItem.isEnabled = !doneDisable
		}
	}
	
	var doneCallBack: (()->Void)?
	
	fileprivate var titleL: UILabel!
	fileprivate var doneItem: UIBarButtonItem!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		titleL = UILabel(color: UIColor.black, font: UIFont.boldSystemFont(ofSize: 15))
		titleL.text = "已经选择\(count)张图片"
		titleL.sizeToFit()
		
		let leftItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		leftItem.width = 60
		let titleItem = UIBarButtonItem(customView: titleL)
		let rightItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(done))
		rightItem.isEnabled = false
		
		self.items = [
			leftItem,
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			titleItem,
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			rightItem,
		]
		
		self.doneItem = rightItem
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func done() {
		doneCallBack?()
	}
}

extension QSImagePickerPhotosToolBar {
	static func newInstance() -> QSImagePickerPhotosToolBar {
		let toolBar = QSImagePickerPhotosToolBar(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
		return toolBar
	}
}
