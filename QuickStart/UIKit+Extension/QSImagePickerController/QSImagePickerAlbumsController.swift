//
//  QSImagePickerAlbumsController.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/29.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit
import Photos

struct QSImagePickerAlbumItem {
	private(set) var name: String
	private(set) var count: Int
	private(set) var phAsset:PHFetchResult<PHAsset>
}



class QSImagePickerAlbumsController: UIViewController {

	fileprivate weak var imagePicker: QSImagePickerController?
	
	fileprivate var tableView: UITableView!
	
	fileprivate lazy var albumItems = [QSImagePickerAlbumItem]()
	fileprivate lazy var cellModels = [CellModelProtocol]()
	
	fileprivate let imageManager = PHCachingImageManager()
	fileprivate lazy var loadImageDic = [QSImagePickerAlbumsCellModel: Bool]()
	
	init(withImagePicker imagePicker: QSImagePickerController) {
		super.init(nibName: nil, bundle: nil)
		self.imagePicker = imagePicker
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		title = "照片"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClick))
		PHPhotoLibrary.shared().register(self)
		readAlbumsData()
		
		tableView = UITableView(frame: CGRect.zero, style: .plain)
		view.addSubview(tableView)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		var constraints = [NSLayoutConstraint]()
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllBottom, metrics: nil, views: ["view": tableView]))
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllLeft, metrics: nil, views: ["view": tableView]))
		view.addConstraints(constraints)
		
		let frameworkBundleID = "com.kxsq.QuickStart"
		let bundle = Bundle(identifier: frameworkBundleID)
		tableView.register(UINib(nibName: "QSImagePickerAlbumsCell", bundle: bundle), forCellReuseIdentifier: "QSImagePickerAlbumsCell")
		
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.reloadData()
		tableView.layoutIfNeeded()
		
		loadImagesForOnscreenRows()
	}
	
	
	private func readAlbumsData() {
		
		albumItems.removeAll()
		cellModels.removeAll()
		loadImageDic.removeAll()
		
		var allPhotosAlbumItem: QSImagePickerAlbumItem?
		var allPhotosCellModel: QSImagePickerAlbumsCellModel?
		
		//smart
		let smartCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
		for index in 0..<smartCollections.count {
			let collection = smartCollections.object(at: index)
			let photos = PHAsset.fetchAssets(in: collection, options: nil)
			if photos.count > 0 {
				let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAsset: photos)
				let cellModel = QSImagePickerAlbumsCellModel(item: albumItem)
				
				if (collection.localizedTitle == "所有照片") {
					allPhotosAlbumItem = albumItem
					allPhotosCellModel = cellModel
				}
				else {
					albumItems.append(albumItem)
					cellModels.append(cellModel)
				}
			}
		}
		
		//用户相册
		let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
		for index in 0..<userCollections.count {
			if let collection = userCollections.object(at: index) as? PHAssetCollection {
				let photos = PHAsset.fetchAssets(in: collection, options: nil)
				if photos.count > 0 {
					let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAsset: photos)
					albumItems.append(albumItem)
					
					let cellModel = QSImagePickerAlbumsCellModel(item: albumItem)
					cellModels.append(cellModel)
				}
			}
		}
		
		//把全部照片放在第一个位置
		if allPhotosAlbumItem != nil && allPhotosCellModel != nil {
			albumItems.insert(allPhotosAlbumItem!, at: 0)
			cellModels.insert(allPhotosCellModel!, at: 0)
		}
		
	}
	
	
	@objc private func cancelButtonClick() {
		imagePicker?.dismiss(completion: nil)
	}
	
	deinit {
		PHPhotoLibrary.shared().unregisterChangeObserver(self)
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension QSImagePickerAlbumsController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellModels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let model = cellModels[indexPath.row]
		if let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as? CellProtocol {
			cell.configureCell?(withModel: model)
			if let cell = cell as? UITableViewCell {
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let model = cellModels[indexPath.row]
		if let height = model.cellHeight {
			return height
		}
		
		if let height = model.cellHeight?(withWidth: tableView.bounds.width) {
			return height
		}
		
		return 0
	}
}

extension QSImagePickerAlbumsController {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			self.loadImagesForOnscreenRows()
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		self.loadImagesForOnscreenRows()
	}
	
	fileprivate func loadImagesForOnscreenRows() {
		if cellModels.count > 0 {
			if let visiblePaths = tableView.indexPathsForVisibleRows {
				for indexPath in visiblePaths {
					if indexPath.row >= 0 && indexPath.row < cellModels.count && indexPath.row >= 0 && indexPath.row < albumItems.count {
						if let cellModel = cellModels[indexPath.row] as? QSImagePickerAlbumsCellModel {
							if cellModel.album == nil && loadImageDic[cellModel] == nil {
								let albumItem = albumItems[indexPath.row]
								if albumItem.phAsset.count > 0 {
									let options = PHImageRequestOptions()
									options.deliveryMode = .opportunistic
									options.isNetworkAccessAllowed = true
									
									loadImageDic[cellModel] = true
									imageManager.requestImage(for: albumItem.phAsset.object(at: 0), targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options, resultHandler: {
										[weak self] image, _ in
										self?.loadImageSuccess(image: image, cellModel: cellModel)
									})
								}
							}
						}
					}
				}
			}
		}
	}
	
	private func loadImageSuccess(image: UIImage?, cellModel: QSImagePickerAlbumsCellModel) {
		if let image = image {
			cellModel.album = image
			loadImageDic[cellModel] = nil
			
			var findIndex = -1
			for (index, oneCellModel) in cellModels.enumerated() {
				if cellModel === oneCellModel {
					findIndex = index
					break
				}
			}
			
			if findIndex != -1 {
				let indexPath = IndexPath(row: findIndex, section: 0)
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}
	}
}

extension QSImagePickerAlbumsController: PHPhotoLibraryChangeObserver {
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		
	}
}
