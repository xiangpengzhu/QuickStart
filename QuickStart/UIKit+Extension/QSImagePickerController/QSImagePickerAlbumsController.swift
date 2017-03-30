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
	private(set) var phAssets: PHFetchResult<PHAsset>
}



/// 相册列表
class QSImagePickerAlbumsController: UIViewController {

	fileprivate weak var imagePicker: QSImagePickerController?
	
	fileprivate var tableView: UITableView!
	
	fileprivate lazy var albumItems = [QSImagePickerAlbumItem]()
	fileprivate lazy var cellModels = [QSImagePickerAlbumsCellModel]()
	fileprivate lazy var phAssets = [PHAsset]()
	
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
	}
	
	
	fileprivate func readAlbumsData() {
		
		albumItems.removeAll()
		cellModels.removeAll()
		loadImageDic.removeAll()
		phAssets.removeAll()
		
		var allPhotosAlbumItem: QSImagePickerAlbumItem?
		var allPhotosCellModel: QSImagePickerAlbumsCellModel?
		var allPhotosPHAsset: PHAsset?
		
		//smart
		let smartCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
		for index in 0..<smartCollections.count {
			let collection = smartCollections.object(at: index)
			let photos = PHAsset.fetchAssets(in: collection, options: nil)
			if photos.count > 0 {
				
				let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAssets: photos)
				let cellModel = QSImagePickerAlbumsCellModel(item: albumItem)
				
				if (collection.localizedTitle == "所有照片") {
					allPhotosAlbumItem = albumItem
					allPhotosCellModel = cellModel
					allPhotosPHAsset = photos.object(at: 0)
				}
				else {
					albumItems.append(albumItem)
					cellModels.append(cellModel)
					phAssets.append(photos.object(at: 0))
				}
			}
		}
		
		//用户相册
		let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
		for index in 0..<userCollections.count {
			if let collection = userCollections.object(at: index) as? PHAssetCollection {
				let photos = PHAsset.fetchAssets(in: collection, options: nil)
				if photos.count > 0 {
					phAssets.append(photos.object(at: 0))
					
					let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAssets: photos)
					albumItems.append(albumItem)
					
					let cellModel = QSImagePickerAlbumsCellModel(item: albumItem)
					cellModels.append(cellModel)
				}
			}
		}
		
		//把全部照片放在第一个位置
		if allPhotosAlbumItem != nil && allPhotosCellModel != nil && allPhotosPHAsset != nil {
			albumItems.insert(allPhotosAlbumItem!, at: 0)
			cellModels.insert(allPhotosCellModel!, at: 0)
			phAssets.insert(allPhotosPHAsset!, at: 0)
		}
		
		let options = PHImageRequestOptions()
		options.isNetworkAccessAllowed = true
		imageManager.startCachingImages(for: phAssets, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options)
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
		let phAsset = phAssets[indexPath.row]
		if let cell = tableView.dequeueReusableCell(withIdentifier: "QSImagePickerAlbumsCell", for: indexPath) as? QSImagePickerAlbumsCell {
			cell.configureCell(withModel: model)
			cell.representedAssetIdentifier = phAsset.localIdentifier
			imageManager.requestImage(for: phAsset, targetSize:CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
				if cell.representedAssetIdentifier == phAsset.localIdentifier {
					cell.imageV.image = image
				}
			})
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath.row >= 0 && indexPath.row < albumItems.count && indexPath.row < cellModels.count {
			let album = albumItems[indexPath.row]
			
			let photosList = QSImagePickerPhotosController()
			photosList.phAssets = album.phAssets
			photosList.title = cellModels[indexPath.row].name
			photosList.imagePicker = self.imagePicker
			self.navigationController?.pushViewController(photosList, animated: true)
		}
	}
}


extension QSImagePickerAlbumsController: PHPhotoLibraryChangeObserver {
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		DispatchQueue.main.sync {
			readAlbumsData()
			tableView.reloadData()
			tableView.layoutIfNeeded()
		}
	}
}
