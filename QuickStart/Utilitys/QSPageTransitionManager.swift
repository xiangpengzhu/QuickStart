//
//  QSPageTransitionManager.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 16/9/22.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit


/// 页面参数类型，用于页面传参使用
public class QSPageParameter: NSObject {
    
    private var paramDic = [String: Any]()
    
    
    /// 存取参数的下标语法
    ///
    /// - parameter key: 参数名
    ///
    /// - returns: 参数值
    public subscript(key: String) -> Any? {
        get {
            return paramDic[key]
        }
        set {
            paramDic[key] = newValue
        }
    }
}


/// 页面跳转管理类
class QSPageTransitionManager: NSObject {
    
}

fileprivate var viewControllerParameterKey = "viewControllerParameterKey"

extension UIViewController {
    
    
    /// UIViewController 绑定参数
    public var parameter: QSPageParameter? {
        get {
            return objc_getAssociatedObject(self, &viewControllerParameterKey) as? QSPageParameter
        }
        set {
            willChangeValue(forKey: "parameter")
            objc_setAssociatedObject(self, &viewControllerParameterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "parameter")
        }
    }
}
