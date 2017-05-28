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
	
    @IBOutlet private weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(testButtonClick), for: .touchUpInside)
	}
    
    @objc private func testButtonClick() {
        let imagePicker = QSImagePickerController()
        imagePicker.maxCount = 3
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

