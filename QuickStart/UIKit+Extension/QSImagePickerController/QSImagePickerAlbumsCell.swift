//
//  QSImagePickerAlbumsCell.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit

class QSImagePickerAlbumsCellModel: NSObject {
	
	fileprivate(set) var name: String
	fileprivate(set) var count: Int
	
	init(item: QSImagePickerAlbumItem) {
		self.name = item.name
		self.count = item.count
		super.init()
	}
}

class QSImagePickerAlbumsCell: UITableViewCell {

	var representedAssetIdentifier: String?

	@IBOutlet var imageV: UIImageView!
	@IBOutlet private var nameL: UILabel!
	@IBOutlet private var countL: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		selectionStyle = .gray
		accessoryType = .disclosureIndicator
    }
	
	func configureCell(withModel model: QSImagePickerAlbumsCellModel) {
		
		imageV.image = UIImage(color: UIColor(colorHexValue: 0xcccccc), rect: CGRect(x: 0, y: 0, width: 1, height: 1))
		nameL.text = model.name
		countL.text = "(\(model.count))"
	}
    
}
