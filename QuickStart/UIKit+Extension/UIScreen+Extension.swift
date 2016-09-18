//
//  UIScreen+extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /**
     计算一个size在设备上对应的大小
     比如320 在iphone 5s上面是320 在iphone6上面就是375
     
     - parameter pixel: 点值
     
     - returns: 本设备对应的大小
     */
    public func systemPixel(_ pixel: CGFloat) -> CGFloat {
        let origin: CGFloat = 320.0;
        let screen = self.bounds.size.width;
        return pixel * screen / origin;
    }
}

