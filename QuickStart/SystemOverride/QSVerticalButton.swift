//
//  QSVerticalButton.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2016/11/24.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit


/// 图片和文字垂直排列，水平居中的button
open class QSVerticalButton: QSTouchEdgeButton {
    
    public var imageTitleSpace: CGFloat = 10 {
        didSet {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    override open func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if let image = self.currentImage {
            if let title = self.currentTitle {
                if let font = self.titleLabel?.font {
                    let size = (title as NSString).size(attributes: [NSFontAttributeName: font])
                    return CGRect(x: (self.bounds.width - image.size.width) / 2.0, y: (self.bounds.height - image.size.height - size.height - imageTitleSpace) / 2.0, width: image.size.width, height: image.size.height)
                }
                else {
                    return CGRect(x: (self.bounds.width - image.size.width) / 2.0, y: (self.bounds.height - image.size.height) / 2.0, width: image.size.width, height: image.size.height)
                }
            }
            else {
                return CGRect(x: (self.bounds.width - image.size.width) / 2.0, y: (self.bounds.height - image.size.height) / 2.0, width: image.size.width, height: image.size.height)
            }
        }
        return CGRect.zero
    }
    
    override open func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let title = self.currentTitle {
            let size = (title as NSString).size(attributes: [NSFontAttributeName: self.titleFont])
            let x: CGFloat = (self.bounds.width - size.width) / 2.0
            var y: CGFloat = 0
            
            if let image = self.currentImage {
                y = (self.bounds.height - image.size.height - size.height - imageTitleSpace) / 2.0 + image.size.height + imageTitleSpace
            }
            else {
                y = (self.bounds.height - size.height) / 2.0
            }
            
            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        
        return CGRect.zero
    }}
