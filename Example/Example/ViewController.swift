//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit
import QuickStart

class ViewController: UIViewController, QSImagePickerControllerDelegate {

	@IBOutlet weak private var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
	}
	
	func buttonClick() {
		let imagePicker = QSImagePickerController()
		imagePicker.delegate = self
		imagePicker.maxCount = 5
		imagePicker.compressImageMaxHeight = 10000
		imagePicker.compressImageMaxWidth = 10000
		imagePicker.show(inViewController: self)
	}

	func imagePicker(imagePicker: QSImagePickerController, didFinishedSelectImages images: [UIImage]) {
		
		let documents = SandboxDirectoryManager.documentDirectory()
		
		for (index, image) in images.enumerated() {
			guard let path = documents?.appendingPathComponent("\(index).jpg") else {
				continue
			}
			let data = UIImageJPEGRepresentation(image, 1.0)
			let url = URL(fileURLWithPath: path)
			do {
				try data?.write(to: url)
			}
			catch {}
		}
	}
}

