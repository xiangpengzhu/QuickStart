//
//  Dictionary+Extension.swift
//  XiuTao
//
//  Created by zhuxiangpeng on 16/4/5.
//  Copyright © 2016年 xpz. All rights reserved.
//

import Foundation

extension Dictionary where Key : Hashable {
    
    public static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
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
