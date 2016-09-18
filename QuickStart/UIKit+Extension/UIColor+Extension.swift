//
//  UIColor+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     用十六进制颜色值和透明度实例化一个颜色
     
     - parameter rgbValue: 十六进制颜色值
     - parameter alpha:    透明度
     
     - returns: UIColor实例
     */
    public convenience init(colorHexValue rgbValue: Int, alpha: CGFloat) {
        self.init(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha)
    }
    
    /**
     用十六进制颜色值实例化一个颜色
     
     - parameter rgbValue: 十六进制颜色值
     
     - returns: UIColor实例
     */
    public convenience init(colorHexValue rgbValue: Int) {
        self.init(colorHexValue: rgbValue, alpha: 1.0)
    }
    
    /**
     用十六进制颜色值字符串实例化一个颜色
     
     - parameter str: 十六进制颜色值字符串
     
     - returns: UIColor实例
     */
    public convenience init(colorHexString str: String) {
        let color = strtol(str, nil, 16)
        self.init(colorHexValue: color)
    }
}
