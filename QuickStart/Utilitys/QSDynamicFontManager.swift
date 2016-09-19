//
//  QSDynamicFontManager.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 16/9/19.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

/**
 动态字体更新管理类
 */
public class QSDynamicFontManager: NSObject {
    public static let `default` = QSDynamicFontManager()
    
    fileprivate lazy var viewToFontDic = NSMapTable<UIView, NSString>.weakToStrongObjects()
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(QSDynamicFontManager.handleDynamicFontChange(notif:)), name: Notification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
}

//MARK: - public function
extension QSDynamicFontManager {
    public func bind(dynamicFontView view: QSDynamicFontView, dynamicFontSytle: UIFontTextStyle) {
        view.dynamicFont = UIFont.preferredFont(forTextStyle: dynamicFontSytle)
        
        if let view = view as? UIView {
            viewToFontDic.setObject(dynamicFontSytle.rawValue as NSString, forKey: view)
        }
    }
}

//MARK: - private function
extension QSDynamicFontManager {
    @objc fileprivate func handleDynamicFontChange(notif: Notification) {
        if notif.name == Notification.Name.UIContentSizeCategoryDidChange {
            let keyE = viewToFontDic.keyEnumerator()
            
            var dynamicFontView = keyE.nextObject() as? QSDynamicFontView
            while dynamicFontView != nil {
                if let key = dynamicFontView as? UIView {
                    if let style = (viewToFontDic.object(forKey: key)) {
                        dynamicFontView!.dynamicFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style as String))
                    }
                }
                dynamicFontView = keyE.nextObject() as? QSDynamicFontView
            }
        }
    }
}

public protocol QSDynamicFontView: NSObjectProtocol, AnyObject {
    var dynamicFont: UIFont? { get set }
}

extension UIButton: QSDynamicFontView {
    public var dynamicFont: UIFont? {
        set {
            self.titleLabel?.font = newValue
        }
        get {
            return self.titleLabel?.font
        }
    }
}
extension UILabel: QSDynamicFontView {
    public var dynamicFont: UIFont? {
        set {
            self.font = newValue
        }
        get {
            return self.font
        }
    }
}
extension UITextView: QSDynamicFontView {
    public var dynamicFont: UIFont? {
        set {
            self.font = newValue
        }
        get {
            return self.font
        }
    }
}
extension UITextField: QSDynamicFontView {
    public var dynamicFont: UIFont? {
        set {
            self.font = newValue
        }
        get {
            return self.font
        }
    }
}
