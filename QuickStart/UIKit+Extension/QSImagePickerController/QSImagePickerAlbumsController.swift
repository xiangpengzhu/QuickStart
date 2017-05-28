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

	var maxCount: Int = 0
	var compressImageMaxWidth: CGFloat = 0
	var compressImageMaxHeight: CGFloat = 0
	
	fileprivate weak var imagePicker: QSImagePickerController?
	fileprivate var tableView: UITableView!
	fileprivate lazy var albumItems = [QSImagePickerAlbumItem]()
    fileprivate var imageManager: PHCachingImageManager?
	
    fileprivate var registeredObserver = false
    
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
        
        requestAuthorization()
	}
    
    fileprivate func requestAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization {
                [weak self] status in
                switch status {
                case .notDetermined:
                    break
                    
                case .restricted, .denied:
                    self?.showDenyMessage()
                    
                case .authorized:
                    self?.registerObserver()
                    
                }
            }
        
        case .restricted, .denied:
            showDenyMessage()
            
        case .authorized:
            registerObserver()
            readAlbumsData()
        }
    }
    
    fileprivate func showDenyMessage() {
        let alert = UIAlertController(title: "温馨提醒", message: "您关闭了相册访问权限，请去设置中开启", preferredStyle: .alert, items: UIAlertItem(title: "确定"))
        self.present(alert, animated: true, completion: nil)
    }
	
    fileprivate func registerObserver() {
        guard registeredObserver == false else {
            return
        }
        
        PHPhotoLibrary.shared().register(self)
        registeredObserver = true
    }
    
    fileprivate func unRegisterObserver() {
        guard registeredObserver else {
            return
        }
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        registeredObserver = false
    }
    
	fileprivate func readAlbumsData() {
		imageManager = PHCachingImageManager()
		albumItems.removeAll()
		
		var allPhotosAlbumItem: QSImagePickerAlbumItem?
		
		let options = PHFetchOptions()
		options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

		//smart
		let smartCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
		for index in 0..<smartCollections.count {
			let collection = smartCollections.object(at: index)
			let photos = PHAsset.fetchAssets(in: collection, options: options)
			if photos.count > 0 {
				
				let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAssets: photos)
				
				if (collection.localizedTitle == "所有照片") {
					allPhotosAlbumItem = albumItem
				}
				else {
					albumItems.append(albumItem)
				}
			}
		}
		
		//用户相册
		let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
		for index in 0..<userCollections.count {
			if let collection = userCollections.object(at: index) as? PHAssetCollection {
				let photos = PHAsset.fetchAssets(in: collection, options: options)
				if photos.count > 0 {
					
					let albumItem = QSImagePickerAlbumItem(name: collection.localizedTitle ?? "未知相册", count: photos.count, phAssets: photos)
					albumItems.append(albumItem)
				}
			}
		}
		
		//把全部照片放在第一个位置
		if allPhotosAlbumItem != nil {
			albumItems.insert(allPhotosAlbumItem!, at: 0)
		}
		
		let phAssets = albumItems.map { $0.phAssets.firstObject! }
		let reqOptions = PHImageRequestOptions()
		reqOptions.isNetworkAccessAllowed = true
		imageManager?.startCachingImages(for: phAssets, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: reqOptions)
	}
	
	
	@objc private func cancelButtonClick() {
		imagePicker?.dismiss(completion: nil)
	}
	
	deinit {
        unRegisterObserver()
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension QSImagePickerAlbumsController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albumItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let albumItem = albumItems[indexPath.row]
		if let cell = tableView.dequeueReusableCell(withIdentifier: "QSImagePickerAlbumsCell", for: indexPath) as? QSImagePickerAlbumsCell {
			cell.representedAssetIdentifier = albumItem.phAssets.firstObject!.localIdentifier
			cell.nameL.text = albumItem.name
			cell.countL.text = "(\(albumItem.count))"
			imageManager?.requestImage(for: albumItem.phAssets.firstObject!, targetSize:CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
				if cell.representedAssetIdentifier == albumItem.phAssets.firstObject!.localIdentifier {
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
		
		if indexPath.row >= 0 && indexPath.row < albumItems.count {
			let album = albumItems[indexPath.row]
			
			let photosList = QSImagePickerPhotosController()
			photosList.phAssets = album.phAssets
			photosList.title = album.name
			photosList.imagePicker = self.imagePicker
			photosList.maxCount = maxCount
			photosList.compressImageMaxHeight = compressImageMaxHeight
			photosList.compressImageMaxWidth = compressImageMaxWidth
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
