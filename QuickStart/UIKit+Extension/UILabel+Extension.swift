//
//  UILabel+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     创建UILabel实例的便捷方法
     
     - parameter color:         textColor
     - parameter font:          label的字体
     - parameter textAlignment: label的对齐属性
     - parameter useAutoLayout: 是否使用autolayout
     - parameter multiLine:     是否是多行label
     
     - returns: UILabel实例
     */
    convenience init(color: UIColor, font: UIFont, textAlignment: NSTextAlignment = .left, useAutoLayout: Bool = false, multiLine: Bool = false) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.textAlignment = textAlignment
        self.textColor = color
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = !useAutoLayout
        self.numberOfLines = multiLine ? 0 : 1
    }
}
