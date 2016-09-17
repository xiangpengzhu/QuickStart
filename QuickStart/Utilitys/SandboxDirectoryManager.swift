//
//  SandboxDirectoryManager.swift
//  QuickStart
//
//  Created by zhu on 16/9/17.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

class SandboxDirectoryManager: NSObject {

    //MARK: - 目录相关
    /**
     屏蔽文件被备份到icloud
     
     - parameter desFilePath: 需要屏蔽的文件路径
     */
    class func addSkipBackupAttribute(_ desFilePath: String) {
        guard FileManager.default.fileExists(atPath: desFilePath) else { return }
        let url = URL(fileURLWithPath: desFilePath)
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
        }
        catch {
            debugPrint("添加文件\(desFilePath)不备份属性失败")
        }
    }
    
    /**
     app documents目录
     
     - returns: documents目录的完整路径
     */
    class func documentDirectory() -> String? {
        let arr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if arr.count > 0 { return arr[0] }
        return nil
    }
    
    /**
     app Library目录
     
     - returns: Library目录的完整路径
     */
    class func libraryDirectory() -> String? {
        let arr = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        if arr.count > 0 { return arr[0] }
        return nil
    }
    
    /**
     app Library/Caches目录
     
     - returns: Library/Caches目录的完整路径
     */
    class func cacheDirectory() -> String? {
        let arr = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        if arr.count > 0 { return arr[0] }
        return nil
    }
}
