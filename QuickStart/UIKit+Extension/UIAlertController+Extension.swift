//
//  UIAlertController+Extension.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2016/11/4.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

public class UIAlertItem {
    var title: String
    var style: UIAlertActionStyle
    var action: (()->Void)?
    
    public init(title: String, style: UIAlertActionStyle = .default, action: (()->Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}

extension UIAlertController {
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, items: UIAlertItem...) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        for item in items {
            let action = UIAlertAction(title: item.title, style: item.style) {
                action in
                item.action?()
            }
            self.addAction(action)
        }
    }
    
    public func show(fromViewController viewController: UIViewController? = nil) {
        if viewController != nil {
            viewController!.present(self, animated: true, completion: nil)
        }
        else if let root = UIApplication.shared.appRootViewController {
            root.present(self, animated: true, completion: nil)
        }
    }
}
