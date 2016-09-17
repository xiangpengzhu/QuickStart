//
//  NSBundle+extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import Foundation

// MARK: - NSBundle扩展
extension Bundle {
    /**
     从个nib文件名字和下标获取一个从nib生成的对象
     
     - parameter nibName: nib文件ming
     - parameter index:   下标
     
     - returns: nib对象
     */
    func nibObject(_ nibName: String, index: Int) -> Any? {
        if let array = self.loadNibNamed(nibName, owner: nil, options: nil) {
            if (index >= 0 && index < array.count) {
                return array[index];
            }
        }
        return nil;
    }
    
}
