//
//  QS.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 16/9/13.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

//MARK: - extension stored property keys 
fileprivate var viewControllerViewModelKey      = "viewControllerViewModelKey"
fileprivate var viewViewModelKey                = "viewViewModelKey"

//MARK: - ViewController
public protocol QSViewController: NSObjectProtocol {
    var viewModel: QSViewModel? { get set }
}

extension UIViewController: QSViewController {
    public var viewModel: QSViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewControllerViewModelKey) as? QSViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewControllerViewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue?.viewController = self
        }
    }
}

//MARK: - View
extension UIView {
    public var viewModel: QSViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewViewModelKey) as? QSViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewViewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue?.view = self
        }
    }
}

//MARK: - viewModel
public class QSViewModel: NSObject {
    public weak var viewController: UIViewController?
    public weak var view: UIView?
}

public class QSDataSourceAndDelegate: NSObject {
    public weak var viewController: UIViewController?
    public var viewModel: QSViewModel?
    
    init(viewController: UIViewController, viewModel: QSViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
        super.init()
    }
    
    private override init() {
        super.init()
    }
}

public class QSTableViewDataSourceAndDelegate: QSDataSourceAndDelegate {
    
}

public class QSCollectionViewDataSourceAndDelegate: QSDataSourceAndDelegate {
    
}

