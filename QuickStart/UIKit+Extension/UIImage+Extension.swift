//
//  UIImage+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK: - 创建图片
    /**
     使用颜色实例化图片
     
     - parameter color: 颜色值
     - parameter rect:  图片大小
     
     - returns: 图片
     */
    convenience init?(color: UIColor, rect: CGRect) {
        
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        guard let data = UIImageJPEGRepresentation(image!, 1.0) else {self.init(); return}
        self.init(data: data)
    }
    
    /**
     使用颜色实例化图片，大小为1像素
     
     - parameter color: 颜色
     
     - returns: 图片
     */
    convenience init?(color: UIColor) {
        self.init(color: color, rect: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
    }
    
    
    /**
     可以模版渲染的图片。用于使用颜色改变图片颜色
     
     - returns: 图片
     */
    func renderingImage() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
