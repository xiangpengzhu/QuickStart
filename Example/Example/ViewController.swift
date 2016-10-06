//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit
import QuickStart
import CoreImage


class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIApplication.shared.appRootViewController
        print(vc)
        
        let root = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        print(root)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = QSPageParameter()
        param[secondViewParamId] = "100"
        param[secondViewParamName] = "hello world"
        let viewController = segue.destination
        viewController.parameter = param
    }
}

