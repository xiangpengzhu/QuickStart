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
	
	@IBOutlet var imageV: UIImageView!
	@IBOutlet var selectImageV: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
