//
//  MVCCore.swift
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
public protocol MVCCoreViewController: NSObjectProtocol {
    var viewModel: MVCCoreViewModel? { get set }
}

extension UIViewController: MVCCoreViewController {
    public var viewModel: MVCCoreViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewControllerViewModelKey) as? MVCCoreViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewControllerViewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue?.viewController = self
        }
    }
}

//MARK: - View
extension UIView {
    public var viewModel: MVCCoreViewModel? {
        get {
            return objc_getAssociatedObject(self, &viewViewModelKey) as? MVCCoreViewModel
        }
        set {
            objc_setAssociatedObject(self, &viewViewModelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue?.view = self
        }
    }
}

//MARK: - viewModel
public class MVCCoreViewModel: NSObject {
    public weak var viewController: UIViewController?
    public weak var view: UIView?
}

public class MVCCoreDataSourceAndDelegate: NSObject {
    public weak var viewController: UIViewController?
    public var viewModel: MVCCoreViewModel?
    
    init(viewController: UIViewController, viewModel: MVCCoreViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
        super.init()
    }
    
    private override init() {
        super.init()
    }
}

public class MVCCoreTableViewDataSourceAndDelegate: MVCCoreDataSourceAndDelegate {
}

public class MVCCoreCollectionViewDataSourceAndDelegate: MVCCoreDataSourceAndDelegate {
    
}

