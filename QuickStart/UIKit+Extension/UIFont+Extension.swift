//
//  UIFont+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIFont {
    /**
     默认字体
     
     - parameter fontSize: 字体size
     
     - returns: 字体
     */
    static func defaultFont(_ fontSize: CGFloat) -> UIFont {
        return self.systemFont(ofSize: fontSize)
    }
    
    /**
     默认加粗字体
     
     - parameter fontSize: 字体size
     
     - returns: 字体
     */
    static func boldFont(_ fontSize: CGFloat) -> UIFont {
        return self.boldSystemFont(ofSize: fontSize)
    }
}
