//
//  File.swift
//  WeiQuan
//
//  Created by zxp on 15/11/5.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit


private var loadingViewKey      = "loadingViewKey"

/// UIViewController 的扩展，实现一些项目中Viewcontroller的通用方法
extension UIViewController {
    
    /// loading 动画的view
    fileprivate var loadingView: UIView? {
        set {
            objc_setAssociatedObject(self, &loadingViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &loadingViewKey) as? UIView
        }
    }
    
    /**
     在界面中添加loading，注意loading会加在view的最上层
     */
    public func startLoading() {
        loadingView?.removeFromSuperview()
        
        
        let oneLoadingView = UIView(frame: self.view.bounds)
        oneLoadingView.backgroundColor = UIColor.white
        self.view.addSubview(oneLoadingView)
        oneLoadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let loadingV = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingV.startAnimating()
        oneLoadingView.addSubview(loadingV)
        loadingV.center = CGPoint(x: oneLoadingView.bounds.size.width/2.0, y: oneLoadingView.bounds.size.height/2.0)
        loadingV.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        loadingView = oneLoadingView
    }
    
    /**
     隐藏func startLoading() 显示的loading
     */
    public func stopLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
