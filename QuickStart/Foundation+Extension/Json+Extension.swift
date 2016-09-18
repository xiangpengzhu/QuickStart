//
//  NSArray+Extension.swift
//  TuCao
//
//  Created by zhuxiangpeng on 16/3/10.
//  Copyright © 2016年 xpz. All rights reserved.
//

import Foundation

extension NSArray {
    public var jsonString: String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                return NSString(bytes: (data as NSData).bytes, length: data.count, encoding: String.Encoding.utf8.rawValue) as? String
            }
            catch {
                return nil
            }
        }
        else {
            return nil
        }
    }
}

extension NSDictionary {
    public var jsonString: String? {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                return NSString(bytes: (data as NSData).bytes, length: data.count, encoding: String.Encoding.utf8.rawValue) as? String
            }
            catch {
                return nil
            }
        }
        else {
            return nil
        }
    }

}
