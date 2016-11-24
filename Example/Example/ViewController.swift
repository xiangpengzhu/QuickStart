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
        
        let button = QSVerticalButton(type: .custom)
        button.backgroundColor = UIColor.red
        button.setImage(#imageLiteral(resourceName: "tab_my"), for: .normal)
        button.setTitle("我的", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(button)
        
        button.frame = CGRect(x: 100, y: 100, width: 40, height: 40)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        button.imageTitleSpace = 5
    }
}

