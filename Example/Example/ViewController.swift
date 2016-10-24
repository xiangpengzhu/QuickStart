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
        
        let list = QSDoublyLinkedList<Int>(rootValue: 0)
        var value1 = list.insertValue(value: 1, afterNode: list.rootNode)
        value1 = list.insertValue(value: -1, beforeNode: value1)
        value1 = list.insertValue(value: -2, beforeNode: value1)
        
        value1 = list.insertValue(value: 10, afterNode: value1.behind!.behind!)
        
        var node: QSDoublyLinkedNode<Int>? = list.rootNode
        while node != nil {
            print(node?.value)
            node = node?.behind
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = QSPageParameter()
        param[secondViewParamId] = "100"
        param[secondViewParamName] = "hello world"
        let viewController = segue.destination
        viewController.parameter = param
    }
}

