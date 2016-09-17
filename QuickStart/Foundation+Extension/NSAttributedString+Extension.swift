//
//  NSAttributedString+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/21.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension NSAttributedString {
    /**
     计算 attributedString的单行size
     
     - returns: 单行size
     */
    func singleLineSize() -> CGSize {
        return self.size()
    }
    
    /**
     计算 attributedString的多行size
     
     - parameter width:  string的宽度
     - parameter height: 要限制的高度，默认是0。0表示高度适配内容多少
     
     - returns: 多行size
     */
    func multiLineSize(textWidth width: CGFloat, maxHeight height: CGFloat = 0) -> CGSize {
        return self.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil).size
    }
}
