//
//  Dictionary+Extension.swift
//  XiuTao
//
//  Created by zhuxiangpeng on 16/4/5.
//  Copyright © 2016年 xpz. All rights reserved.
//

import Foundation

extension Dictionary where Key : Hashable {
    
    public static func +(lhs: [Key: Value]?, rhs: [Key: Value]) -> [Key: Value] {
        guard let lhs = lhs else {
            return rhs
        }
        
        var dic = [Key: Value]()
        for (k, v) in lhs {
            dic[k] = v
        }
        for (k, v) in rhs {
            dic[k] = v
        }
        
        return dic
    }
    
    public static func +(lhs: [Key: Value], rhs: [Key: Value]?) -> [Key: Value] {
        guard let rhs = rhs else {
            return lhs
        }
        
        var dic = [Key: Value]()
        for (k, v) in lhs {
            dic[k] = v
        }
        
        for (k, v) in rhs {
            dic[k] = v
        }
        
        return dic
    }
}
