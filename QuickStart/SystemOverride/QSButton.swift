//
//  QSButton.swift
//  QuickStart
//
//  Created by zhu on 16/9/18.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

open class QSButton: UIButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addFontSizeChangeNotification()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        removeFontSizeChangeNotification()
    }
}

extension QSButton {
    fileprivate func addFontSizeChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(QSButton.handleNotification(notif:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    fileprivate func removeFontSizeChangeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    @objc private func handleNotification(notif: NSNotification) {
        if notif.name == NSNotification.Name.UIContentSizeCategoryDidChange {
            self.titleLabel?.font = self.titleLabel?.font
        }
    }
}
