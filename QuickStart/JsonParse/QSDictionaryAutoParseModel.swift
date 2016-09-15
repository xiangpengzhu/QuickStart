//
//  QSDictionaryAutoParseModel.swift
//  QuickStart
//
//  Created by zhu on 16/9/15.
//  Copyright © 2016年 zxp. All rights reserved.
//

import Foundation

open class QSDictionaryAutoParseModel: NSObject {
    
    
    public final func parse(fromJsonObject obj: Any, typeGenerator: ((String) -> QSDictionaryAutoParseModel?)? = nil) -> Bool {
        guard let dic = obj as? NSDictionary else {
            return false
        }
        
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let label = child.label else {
                continue
            }
            
            let value = child.value
            let childMirror = Mirror(reflecting: value)
            let childType = "\(childMirror.subjectType)"
            print(child.label, child.value, childMirror.subjectType)
            
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
                if let model = typeGenerator?(childType), let modelDic = dic[label] {
                    if model.parse(fromJsonObject: modelDic, typeGenerator: typeGenerator) {
                        self.setValue(model, forKey: label)
                    }
                }
                
                break
            }
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
                
            default:
                if let model = typeGenerator?(elementType) {
                    if model.parse(fromJsonObject: obj, typeGenerator: typeGenerator) {
                        return model
                    }
                }
                return nil
            }
        }
        
        return returnArray
    }
}
