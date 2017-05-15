//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
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
	"dic_info": [
		"key": "value",
		"1": [
			[
				"id": "1",
				"name": "xx",
			],
			[
				"id": "2",
				"name": "xxx",
			],
		]
	],
	"products": [
		[
			"id": "1",
			"name": "xx",
			],
		[
			"id": "2",
			"name": "xxx",
		],
	]
]



class ResponseData: QSDictionaryAutoParseModel {
 
	private(set) var code: Int = 0
	private(set) var doubleValue: Double = 0.0
	private(set) var floatValue: Float = 0.0
 
	private(set) var msg = ""
	private(set) var data = [Person]()
 
	private(set) var person = Person()
	private(set) var dic_info = NSDictionary()
	private(set) var products = [NSDictionary]()
}

class Person: QSDictionaryAutoParseModel {
	var name = ""
	var age = 0
}


class ViewController: UIViewController, QSImagePickerControllerDelegate {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let resp = ResponseData()
		if resp.parse(fromJsonObject: dic) {
			print(resp)
		}
	}
}

