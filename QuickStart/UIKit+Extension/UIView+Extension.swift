//
//  UIView+Extension.swift
//  ShuFaLibrary
//
//  Created by zhu on 16/4/2.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit

extension UIView {
    
    var screenshotImage: UIImage? {
        var image: UIImage?        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
