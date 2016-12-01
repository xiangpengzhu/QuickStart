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

let dic: [String : Any] = [
    "success": true,
    "code": 0,
    "msg": "success",
    "doubleValue": 3.14159265,
    "floatValue": 3.14,
    "data": [
        [
            "name": "zxp",
            "age": 10
        ],
        [
            "name": "ttt",
            "age": 12
        ],
    ],
    "person": [
        "name": "ttt",
        "age": 12
    ],
]



class ResponseData: QSDictionaryAutoParseModel {
    
    private(set) var success: Bool = false
    private(set) var code: Int = 0
    private(set) var doubleValue: Double = 0.0
    private(set) var floatValue: Float = 0.0
    
    private(set) var msg = ""
    private(set) var data = [Person]()
    
    private(set) var person = Person()
}

class Person: QSDictionaryAutoParseModel {
    var name = ""
    var age = 0
}

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resp = ResponseData()
        let result = resp.parse(fromJsonObject: dic) { type in
            if type == "Person" {
                return Person()
            }
            return nil
        }
        
        if result {
        }


    }
}

