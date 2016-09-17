//
//  UITableViewCell+Extension.swift
//  XiuTao
//
//  Created by zhuxiangpeng on 16/8/30.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit

extension UITableViewCell {
    var currentViewController: UIViewController? {
        
        var next = self.superview
        while next != nil {
            let responder = next?.next
            if let responder = responder , responder is UIViewController {
                return responder as? UIViewController
            }
            
            next = next?.superview
        }
        
        return nil
    }
}
