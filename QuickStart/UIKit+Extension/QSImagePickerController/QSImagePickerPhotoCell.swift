//
//  QSImagePickerPhotoCell.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit

class QSImagePickerPhotoCell: UICollectionViewCell {

	var representedAssetIdentifier: String?
	var disable: Bool = false {
		didSet {
			maskV?.removeFromSuperview()
			maskV = nil
			
			if disable {
				selectImageV.image = nil
				
				let maskV = UIView(frame: contentView.bounds)
				maskV.backgroundColor = UIColor(colorHexValue: 0xffffff, alpha: 0.7)
				contentView.addSubview(maskV)
				
				maskV.translatesAutoresizingMaskIntoConstraints = false
				var constraints = [NSLayoutConstraint]()
				constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllBottom, metrics: nil, views: ["view": maskV]))
				constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllLeft, metrics: nil, views: ["view": maskV]))
				contentView.addConstraints(constraints)

				
				self.maskV = maskV
			}
		}
	}
	@IBOutlet var imageV: UIImageView!
	@IBOutlet var selectImageV: UIImageView!
	
	private var maskV: UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
