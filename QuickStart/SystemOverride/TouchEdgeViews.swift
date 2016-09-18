//
//  TouchEdgeViews.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 16/9/18.
//  Copyright © 2016年 zQS. All rights reserved.
//

import UIKit

/**
 *  扩大View的响应范围的协议
 */
protocol QSViewTouchEdgeExtend {
    var responseInsets: UIEdgeInsets {get set}
}

extension UIView {
    
    /**
     计算一个点是否在view的响应范围内
     
     - parameter point:					点
     - parameter responseInsets:        扩大边界
     
     - returns: 是否可以响应
     */
    fileprivate func pointCanResponse(_ point: CGPoint, responseInsets: UIEdgeInsets) -> Bool {
        let parentLocation = self.convert(point, to: self.superview)
        
        var responseRect = self.frame;
        responseRect.origin.x -= responseInsets.left;
        responseRect.origin.y -= responseInsets.top;
        responseRect.size.width += (responseInsets.left + responseInsets.right);
        responseRect.size.height += (responseInsets.top + responseInsets.bottom);
        
        return responseRect.contains(parentLocation);
    }
}

/// 可扩大响应范围的UIView
open class QSTouchEdgeView: UIView, QSViewTouchEdgeExtend {
    /// 扩大的边界
    public var responseInsets = UIEdgeInsets.zero
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.pointCanResponse(point, responseInsets: responseInsets)
    }
}

/// 可扩大响应范围的UIScrollView
open class QSTouchEdgeScrollView: UIScrollView, QSViewTouchEdgeExtend {
    /// 扩大的边界
    public var responseInsets = UIEdgeInsets.zero
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.pointCanResponse(point, responseInsets: responseInsets)
    }
}

/// 可扩大响应范围的UILabel
open class QSTouchEdgeLabel: UILabel, QSViewTouchEdgeExtend {
    /// 扩大的边界
    public var responseInsets = UIEdgeInsets.zero
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.pointCanResponse(point, responseInsets: responseInsets)
    }
}

/// 可扩大响应范围的UIButton
open class QSTouchEdgeButton: UIButton, QSViewTouchEdgeExtend {
    /// 扩大的边界
    public var responseInsets = UIEdgeInsets.zero
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.pointCanResponse(point, responseInsets: responseInsets)
    }
}

/// 可扩大响应范围的UIButton
open class QSTouchEdgeImageView: UIImageView, QSViewTouchEdgeExtend {
    /// 扩大的边界
    public var responseInsets = UIEdgeInsets.zero
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.pointCanResponse(point, responseInsets: responseInsets)
    }
}
