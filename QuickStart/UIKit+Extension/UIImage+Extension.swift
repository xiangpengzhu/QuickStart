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
    public convenience init?(color: UIColor, rect: CGRect) {
        
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
    public convenience init?(color: UIColor) {
        self.init(color: color, rect: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
    }
    
    
    /**
     可以模版渲染的图片。用于使用颜色改变图片颜色
     
     - returns: 图片
     */
    public func renderingImage() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    
    /// 在不改变图片宽高比例的情况下，适配图片大小
    ///
    /// - Parameter size: 要适配的大小
    /// - Returns: 新的图片
    public func adjustToSize(size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            return self
        }
        
        let limitSize = size
        var size = self.size
        guard size.width > 0 && size.height > 0 else {
            return self
        }
        
        var needChange = false
        if size.width / size.height > limitSize.width / limitSize.height {
            //以宽度为准
            if size.width > limitSize.width {
                let r = size.width / limitSize.width
                size = CGSize(width: limitSize.width, height: size.height / r)
                needChange = true
            }
        }
        else {
            //以高度为准
            if size.height > limitSize.height {
                let r = size.height / limitSize.height
                size = CGSize(width: size.width / r, height: limitSize.height)
                needChange = true
            }
        }
        
        if (needChange) {
            UIGraphicsBeginImageContext(size);
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
            self.draw(in: rect)
            let newimg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return newimg;
        }
        else {
            return self;
        }
    }
}
