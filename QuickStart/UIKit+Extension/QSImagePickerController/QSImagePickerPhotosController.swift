//
//  QSImagePickerPhotosController.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2017/3/30.
//  Copyright © 2017年 zxp. All rights reserved.
//

import UIKit
import Photos

private let itemSize: CGFloat = 75

/// 相片列表
class QSImagePickerPhotosController: UIViewController {

	var phAssets: PHFetchResult<PHAsset>!
	weak var imagePicker: QSImagePickerController?
	var maxCount: Int = 0
	var compressImageMaxWidth: CGFloat = 0
	var compressImageMaxHeight: CGFloat = 0

	fileprivate let imageManager = PHCachingImageManager()
	fileprivate var previousPreheatRect = CGRect.zero
	fileprivate var thumbnailSize: CGSize!

	fileprivate var selectedAssets = [PHAsset: Bool]()
	fileprivate var selectedAssetArray = [PHAsset]()
	
	fileprivate var collectionView: UICollectionView!
	fileprivate var toolBar: QSImagePickerPhotosToolBar!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.white
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClick))
		resetCachedAssets()
		PHPhotoLibrary.shared().register(self)
		
		selectedAssets.removeAll()
		selectedAssetArray.removeAll()
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
		flowLayout.minimumInteritemSpacing = 4
		flowLayout.minimumLineSpacing = 4
		flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4)
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = UIColor.white
		collectionView.alwaysBounceVertical = true
		view.addSubview(collectionView)
		
		toolBar = QSImagePickerPhotosToolBar.newInstance()
		toolBar.doneCallBack = {
			[weak self] in self?.done()
		}
		view.addSubview(toolBar)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		toolBar.translatesAutoresizingMaskIntoConstraints = false
		
		var constraints = [NSLayoutConstraint]()
		constraints.append(NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: 44))
		
		constraints.append(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: toolBar, attribute: .top, multiplier: 1, constant: 0))
		view.addConstraints(constraints)
		
		let frameworkBundleID = "com.kxsq.QuickStart"
		let bundle = Bundle(identifier: frameworkBundleID)
		
		collectionView.register(UINib(nibName: "QSImagePickerPhotoCell", bundle: bundle), forCellWithReuseIdentifier: "QSImagePickerPhotoCell")
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ErrorCell")
		
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Determine the size of the thumbnails to request from the PHCachingImageManager
		let scale = UIScreen.main.scale
		thumbnailSize = CGSize(width: itemSize * scale, height: itemSize * scale)
		
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateCachedAssets()
	}

	@objc private func cancelButtonClick() {
		imagePicker?.dismiss(completion: nil)
	}
	
	
	/// 完成
	private func done() {
		imagePicker?.startDoneLoading()
		
		DispatchQueue.global().async {
			[weak self] in self?.readSelectedImages()
		}
	}
	
	private func readSelectedImages() {
		let options = PHImageRequestOptions()
		options.deliveryMode = .highQualityFormat
		options.isSynchronous = true
		options.isNetworkAccessAllowed = true
		options.resizeMode = .fast
		
		var images = [UIImage]()
		for asset in selectedAssetArray {
			imageManager.requestImage(for: asset, targetSize: CGSize(width: compressImageMaxWidth, height: compressImageMaxHeight), contentMode: .aspectFit, options: options, resultHandler: { image, _ in
				if let image = image {
					print(image)
					images.append(image)
				}
			})
		}
		
		DispatchQueue.main.async {
			[weak self] in
			self?.readSelectedImagesSuccess(images: images)
		}
	}
	
	private func readSelectedImagesSuccess(images: [UIImage]) {
		imagePicker?.stopDoneLoading()
		if let imagePicker = imagePicker {
			imagePicker.dismiss(completion: {
				imagePicker.delegate?.imagePicker?(imagePicker: imagePicker, didFinishedSelectImages: images)
			})
		}
	}
	
	deinit {
		PHPhotoLibrary.shared().unregisterChangeObserver(self)
	}
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout 回调
extension QSImagePickerPhotosController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return phAssets.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let asset = phAssets.object(at: indexPath.item)
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSImagePickerPhotoCell", for: indexPath) as? QSImagePickerPhotoCell
			else {
				return collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath)
		}
		
		let frameworkBundleID = "com.kxsq.QuickStart"
		let bundle = Bundle(identifier: frameworkBundleID)
		let imageName = selectedAssets[asset] == nil ? "image_picker_select" : "image_picker_select_h"
		
		cell.selectImageV.image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
		cell.disable = asset.disable
		cell.representedAssetIdentifier = asset.localIdentifier
		imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
			if cell.representedAssetIdentifier == asset.localIdentifier {
				cell.imageV.image = image
			}
		})
		
		return cell

	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let asset = phAssets.object(at: indexPath.item)
		guard asset.disable == false else {
			//视频和live 图片不能选择
			return
		}
		
		let options = PHImageRequestOptions()
		options.deliveryMode = .highQualityFormat
		options.isNetworkAccessAllowed = true
		options.resizeMode = .fast

		
		if selectedAssets[asset] == nil {
			if selectedAssets.count >= maxCount {
				let alert = UIAlertController(title: "温馨提醒", message: "最多只能选取\(maxCount)张图片哦", preferredStyle: .alert, items: UIAlertItem(title: "确定"))
				self.present(alert, animated: true, completion: nil)
				return
			}
			selectedAssets[asset] = true
			selectedAssetArray.append(asset)
			
			imageManager.startCachingImages(for: [asset], targetSize: CGSize(width: compressImageMaxWidth, height: compressImageMaxHeight), contentMode: .aspectFit, options: options)
		}
		else {
			selectedAssets[asset] = nil
			
			var findIndex = -1
			for (index, oneAsset) in selectedAssetArray.enumerated() {
				if asset === oneAsset {
					findIndex = index
					break
				}
			}
			if findIndex != -1 {
				selectedAssetArray.remove(at: findIndex)
				imageManager.stopCachingImages(for: [asset], targetSize: CGSize(width: compressImageMaxWidth, height: compressImageMaxHeight), contentMode: .aspectFit, options: options)
			}
		}
		
		collectionView.reloadData()
		
		toolBar.doneDisable = selectedAssets.count == 0
		toolBar.count = selectedAssets.count
	}
}

extension QSImagePickerPhotosController {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateCachedAssets()
	}
	
	fileprivate func resetCachedAssets() {
		imageManager.stopCachingImagesForAllAssets()
		previousPreheatRect = .zero
	}
	
	fileprivate func updateCachedAssets() {
		// Update only if the view is visible.
		guard isViewLoaded && view.window != nil else { return }
		
		// The preheat window is twice the height of the visible rect.
		let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
		let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
		
		// Update only if the visible area is significantly different from the last preheated area.
		let delta = abs(preheatRect.midY - previousPreheatRect.midY)
		guard delta > view.bounds.height / 3 else { return }
		
		// Compute the assets to start caching and to stop caching.
		let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
		let addedAssets = addedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in phAssets.object(at: indexPath.item) }
		let removedAssets = removedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in phAssets.object(at: indexPath.item) }
		
		// Update the assets the PHCachingImageManager is caching.
		imageManager.startCachingImages(for: addedAssets,
		                                targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		imageManager.stopCachingImages(for: removedAssets,
		                               targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		
		// Store the preheat rect to compare against in the future.
		previousPreheatRect = preheatRect
	}
	
	fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
		if old.intersects(new) {
			var added = [CGRect]()
			if new.maxY > old.maxY {
				added += [CGRect(x: new.origin.x, y: old.maxY,
				                 width: new.width, height: new.maxY - old.maxY)]
			}
			if old.minY > new.minY {
				added += [CGRect(x: new.origin.x, y: new.minY,
				                 width: new.width, height: old.minY - new.minY)]
			}
			var removed = [CGRect]()
			if new.maxY < old.maxY {
				removed += [CGRect(x: new.origin.x, y: new.maxY,
				                   width: new.width, height: old.maxY - new.maxY)]
			}
			if old.minY < new.minY {
				removed += [CGRect(x: new.origin.x, y: old.minY,
				                   width: new.width, height: new.minY - old.minY)]
			}
			return (added, removed)
		} else {
			return ([new], [old])
		}
	}

}

extension QSImagePickerPhotosController: PHPhotoLibraryChangeObserver {
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		
	}
}

private extension UICollectionView {
	func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
		let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
		return allLayoutAttributes.map { $0.indexPath }
	}
}

extension PHAsset {
	
	/// 视频和photolive图片不能被选中
	var disable: Bool {
		if #available(iOS 9.1, *) {
			if self.mediaType == .video || self.mediaSubtypes.contains(.photoLive) {
				return true
			}
		} else {
			if self.mediaType == .video {
				return true
			}
		}
		
		return false
	}
}
