//
//  QSImagePickerAlbumsCell.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit


class QSImagePickerAlbumsCell: UITableViewCell {

	var representedAssetIdentifier: String?

	@IBOutlet var imageV: UIImageView!
	@IBOutlet var nameL: UILabel!
	@IBOutlet var countL: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		selectionStyle = .gray
		accessoryType = .disclosureIndicator
    }
}
