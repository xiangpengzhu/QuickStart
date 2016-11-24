//
//  QSVerticalButton.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2016/11/24.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit


/// 图片和文字垂直排列，水平居中的button
public class QSVerticalButton: QSTouchEdgeButton {
    
    public var imageTitleSpace: CGFloat = 10 {
        didSet {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
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
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        if let title = self.currentTitle {
            if let image = self.currentImage {
                return CGRect(x: (self.bounds.width - rect.width) / 2.0, y: (self.bounds.height - image.size.height - rect.height - imageTitleSpace) / 2.0 + image.size.height + imageTitleSpace, width: rect.width, height: rect.height)
            }
            else {
                return rect
            }
        }
        
        return CGRect.zero
    }
}
