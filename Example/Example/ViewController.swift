//
//  ViewController.swift
//  Example
//
//  Created by zhuxiangpeng on 16/9/13.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit
import QuickStart

let dic: [String : Any] = [
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
    
    private(set) var code: Int = 0
    private(set) var doubleValue: Double = 0.0
    private(set) var floatValue: Float = 0.0
    
    private(set) var msg = ""
    private(set) var data = [Person]()
    
    private(set) var person = Person()
    
    class Person: QSDictionaryAutoParseModel {
        var name = ""
        var age = 0
    }
}



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let resp = ResponseData()
        let result = resp.parse(fromJsonObject: dic) { type in
            if type == "Person" {
                return ResponseData.Person()
            }
            return nil
        }
        if result {
            ///
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

