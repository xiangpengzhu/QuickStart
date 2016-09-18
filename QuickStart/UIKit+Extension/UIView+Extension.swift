//
//  UIView+Extension.swift
//  ShuFaLibrary
//
//  Created by zhu on 16/4/2.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit

extension UIView {
    
    public var screenshotImage: UIImage? {
        var image: UIImage?        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    public var currentViewController: UIViewController? {
        
        var next = self.superview
        while next != nil {
            let responder = next?.next
            if let responder = responder , responder is UIViewController {
                return responder as? UIViewController
            }
            
            next = next?.superview
        }
        
        return nil
    }
    
}
