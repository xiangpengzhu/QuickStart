//
//  String+Extension.swift
//  ShuFaLibrary
//
//  Created by zhu on 15/10/15.
//  Copyright © 2015年 xpz. All rights reserved.
//

import UIKit
import CommonCrypto

// MARK: - String类型扩展
extension String {
    
    /// 字符串md5
    public var md5: String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let byteRet = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5((data as NSData).bytes, CC_LONG(data.count), byteRet)
        
        var str = ""
        for i in 0..<16 {
            str = String(format: "%@%02x", str, byteRet[i])
        }
        byteRet.deinitialize(count: Int(CC_MD5_DIGEST_LENGTH))
        byteRet.deallocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        return str
    }
    
    ///字符串sha1
    public var sha1: String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), digest)
        
        var str = ""
        for index in 0 ..< Int(CC_SHA1_DIGEST_LENGTH) {
            str = String(format: "%@%02x", str, digest[index])
        }
        digest.deinitialize(count: Int(CC_SHA1_DIGEST_LENGTH))
        digest.deallocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        return str
    }
    
    //MARK: - 字符串正则表达式
    /**
    字符串是否满足正则表达式
    
    - parameter regex: 正则字符串
    
    - returns: 是否满足
    */
    fileprivate func matchRegex(_ regex: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    /// 字符串是否是邮件格式
    public var isEmail: Bool {
        return self.matchRegex("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$")
    }
    
    public var isCellPhone: Bool {
        return self.matchRegex("^1\\d{10}$")
    }
    
    /**
     可选字符串转化成空字符串
     
     - parameter str:	要转换的字符串
     
     - returns: 返回的字符串
     */
    public static func safeString(_ str: String?) -> String {
        
        guard let string = str else { return "" }
        return string
    }
    
    
    /// 删除字符串两边的空格和空行
    ///
    /// - Returns: 返回字符串
    public func strip() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    //MARK: - 目录相关，封装NSString相同的方法
    
    public static func path(withComponents components: [String]) -> String {
        return NSString.path(withComponents: components)
    }
    
    public var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    
    public var isAbsolutePath: Bool {
        return (self as NSString).isAbsolutePath
    }
    
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    
    public var abbreviatingWithTildeInPath: String {
        return (self as NSString).abbreviatingWithTildeInPath
    }
    
    public var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
    
    
    public var standardizingPath: String {
        return (self as NSString).standardizingPath
    }
    
    
    public var resolvingSymlinksInPath: String {
        return (self as NSString).resolvingSymlinksInPath
    }
    
    public func strings(byAppendingPaths paths: [String]) -> [String] {
        return (self as NSString).strings(byAppendingPaths: paths)
    }
}


