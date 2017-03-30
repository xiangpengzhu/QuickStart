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

	fileprivate let imageManager = PHCachingImageManager()
	fileprivate var previousPreheatRect = CGRect.zero
	fileprivate var thumbnailSize: CGSize!

	fileprivate var selectedAssets = [PHAsset: Bool]()
	
	fileprivate var collectionView: UICollectionView!
	fileprivate var toolBar: QSImagePickerPhotosToolBar!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.white
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClick))
		resetCachedAssets()
		PHPhotoLibrary.shared().register(self)
		
		selectedAssets.removeAll()
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
		flowLayout.minimumInteritemSpacing = 4
		flowLayout.minimumLineSpacing = 4
		flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4)
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
		collectionView.backgroundColor = UIColor.white
		view.addSubview(collectionView)
		
		toolBar = QSImagePickerPhotosToolBar.newInstance()
		view.addSubview(toolBar)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		toolBar.translatesAutoresizingMaskIntoConstraints = false
		
		var constraints = [NSLayoutConstraint]()
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: .alignAllBottom, metrics: nil, views: ["collectionView": collectionView, "toolBar": toolBar]))
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolBar]|", options: .alignAllBottom, metrics: nil, views: ["collectionView": collectionView, "toolBar": toolBar]))
		constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView][toolBar(44)]|", options: .alignAllLeft, metrics: nil, views: ["collectionView": collectionView, "toolBar": toolBar]))
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
		if selectedAssets[asset] == nil {
			selectedAssets[asset] = true
		}
		else {
			selectedAssets[asset] = nil
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
