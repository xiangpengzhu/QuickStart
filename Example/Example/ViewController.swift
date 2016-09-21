//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit
import QuickStart
import CoreImage


class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = #imageLiteral(resourceName: "1")
        
        /*
        if let ciImage = CIImage(image: image) {
            let outImage = blur(blurName: Blur.CIGaussianBlur.rawValue, radius: 100)(ciImage)
            let image = UIImage(ciImage: outImage)
            imageView.image = image
        }
 */
    }
}

