//
//  QSDictionaryAutoParseModel.swift
//  QuickStart
//
//  Created by zhu on 16/9/15.
//  Copyright © 2016年 zxp. All rights reserved.
//

import Foundation


/*
自动解析类json object 的类


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


 let resp = ResponseData()
 let result = resp.parse(fromJsonObject: dic) { type in
    if type == "Person" {
        return Person()
    }
    else type == "Student" {
        return Student()
    }
    return nil
 }
 
 if result {
 ///
 }
 
 */
open class QSDictionaryAutoParseModel: NSObject {
    
    /**
     解析方法
     obj 需要解析的jsonObject
     typeGenerator 类型生成器，根据一个自定义类型的字符串，返回一个这个自定义类型的实例
    */
    public func parse(fromJsonObject obj: Any?, typeGenerator: ((String) -> QSDictionaryAutoParseModel?)? = nil) -> Bool {
        guard let dic = obj as? NSDictionary else {
            return false
        }
        
        var selfMir: Mirror? = Mirror(reflecting: self)
        while let mirror = selfMir {
            
            for child in mirror.children {
                guard let label = child.label else {
                    continue
                }
                
                let value = child.value
                let childMirror = Mirror(reflecting: value)
                let childType = "\(childMirror.subjectType)"
                
                switch childType {
                case "Int":
                    if let intValue = dic[label] as? Int {
                        self.setValue(intValue, forKey: label)
                    }
                    
                case "Float":
                    if let floatValue = dic[label] as? Float {
                        self.setValue(floatValue, forKey: label)
                    }
                    
                case "Double":
                    if let doubleValue = dic[label] as? Double {
                        self.setValue(doubleValue, forKey: label)
                    }
                    
                case "String":
                    if let stringValue = dic[label] as? String {
                        self.setValue(stringValue, forKey: label)
                    }
                    
                case "Bool":
                    if let boolValue = dic[label] as? Bool {
                        self.setValue(boolValue, forKey: label)
                    }
                    
                case let type where type.hasPrefix("Array<") && type.hasSuffix(">"):
                    if let preRange = type.range(of: "Array<"), let sufRange = type.range(of: ">") {
                        let startIndex = preRange.upperBound
                        let endIndex = sufRange.lowerBound
                        
                        let eleType = type.substring(with: Range<String.Index>(startIndex..<endIndex))
                        if let originArray = dic[label] as? Array<Any> {
                            if let arrayValue = parse(fromArray: originArray, elementType: eleType, typeGenerator: typeGenerator) {
                                self.setValue(arrayValue, forKey: label)
                            }
                        }
                    }
                    
                    break
                    
                default:
					if let modelDic = dic[label] {
						if let model = typeGenerator?(childType) {
							//解析类
							if model.parse(fromJsonObject: modelDic, typeGenerator: typeGenerator) {
								self.setValue(model, forKey: label)
							}
						}
						else if (childType.hasPrefix("Dictionary") || childType == "NSDictionary"), let modelDic = modelDic as? NSDictionary {
							//解析字典
							self.setValue(modelDic, forKey: label)
						}
					}
					
                    break
                }
            }
            selfMir = selfMir?.superclassMirror
        }
        
        
        return true
    }
    
    private func parse(fromArray array: Array<Any>, elementType: String,  typeGenerator: ((String) -> QSDictionaryAutoParseModel?)? = nil) -> Array<Any>? {
        
        let returnArray = array.flatMap { (obj: Any) -> Any? in
            switch elementType {
            case "Int":
                return obj as? Int
                
            case "Float":
                return obj as? Float
                
            case "Double":
                return obj as? Double
                
            case "String":
                return obj as? String
                
            case "Bool":
                return obj as? Bool
                
            default:
                if let model = typeGenerator?(elementType) {
                    if model.parse(fromJsonObject: obj, typeGenerator: typeGenerator) {
                        return model
                    }
                }
				else if (elementType.hasPrefix("Dictionary") || elementType == "NSDictionary"), let obj = obj as? NSDictionary {
					return obj
				}
                return nil
            }
        }
        
        return returnArray
    }
}
