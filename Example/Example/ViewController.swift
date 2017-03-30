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
		imagePicker.show(inViewController: self)
	}

	
}

