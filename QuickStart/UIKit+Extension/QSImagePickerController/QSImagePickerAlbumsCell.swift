//
//  QSImagePickerAlbumsCell.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit

class QSImagePickerAlbumsCellModel: NSObject, CellModelProtocol {
	
	var identifier: String {
		return "QSImagePickerAlbumsCell"
	}
	
	var cellHeight: CGFloat {
		return 60
	}
	
	var album: UIImage?
	fileprivate(set) var name: String
	fileprivate(set) var count: Int
	
	init(item: QSImagePickerAlbumItem) {
		self.name = item.name
		self.count = item.count
		super.init()
	}
}

class QSImagePickerAlbumsCell: UITableViewCell, CellProtocol {

	@IBOutlet private var imageV: UIImageView!
	@IBOutlet private var nameL: UILabel!
	@IBOutlet private var countL: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		selectionStyle = .gray
		accessoryType = .disclosureIndicator
    }
	
	func configureCell(withModel model: CellModelProtocol) {
		guard let model = model as? QSImagePickerAlbumsCellModel else {
			return
		}
				
		if model.album == nil {
			imageV.image = UIImage(color: UIColor.lightGray, rect: CGRect(x: 0, y: 0, width: 1, height: 1))
		}
		else {
			imageV.image = model.album
		}
		
		nameL.text = model.name
		countL.text = "(\(model.count))"
	}
    
}
