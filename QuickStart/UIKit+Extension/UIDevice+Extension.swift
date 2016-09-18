//
//  UIDevice+Extension.swift
//  WeiQuan
//
//  Created by zxp on 15/10/16.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

// MARK: - UIDevice扩展
extension UIDevice {

    /// 是否是ipad
    public var isIpad: Bool {
        get {
            return self.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }
    }
}
