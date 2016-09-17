//
//  String+Extension.swift
//  ShuFaLibrary
//
//  Created by zhu on 15/10/15.
//  Copyright © 2015年 xpz. All rights reserved.
//

import UIKit


//// MARK: - 字符串扩展
//extension NSString {
//    
//
//    /// 字符串md5
//    var md5: NSString? {
//        guard let data = self.data(using: String.Encoding.utf8.rawValue) else { return nil }
//        
//        let byteRet = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5((data as NSData).bytes, CC_LONG(data.count), byteRet)
//        
//        var str: NSString = ""
//        for i in 0..<16 {
//            str = NSString(format: "%@%02x", str, byteRet[i])
//        }
//        byteRet.deinitialize(count: Int(CC_MD5_DIGEST_LENGTH))
//        byteRet.deallocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
//        return str
//    }
//    
//    ///字符串sha1
//    var sha1: NSString? {
//        guard let data = self.data(using: String.Encoding.utf8.rawValue) else { return nil }
//        
//        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))
//        
//        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), digest)
//        
//        var str: NSString = ""
//        for index in 0 ..< Int(CC_SHA1_DIGEST_LENGTH) {
//            str = NSString(format: "%@%02x", str, digest[index])
//        }
//        digest.deinitialize(count: Int(CC_SHA1_DIGEST_LENGTH))
//        digest.deallocate(capacity: Int(CC_SHA1_DIGEST_LENGTH))
//        return str;
//    }
//    
//    
//    //MARK: - 字符串正则表达式
//    /**
//    字符串是否满足正则表达式
//    
//    - parameter regex: 正则字符串
//    
//    - returns: 是否满足
//    */
//    func matchRegex(_ regex: NSString) -> Bool {
//        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
//        return pred.evaluate(with: self)
//    }
//    
//    /// 字符串是否是邮件格式
//    var isEmail: Bool {
//        return self.matchRegex("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$")
//    }
//    
//    var isCellPhone: Bool {
//        return self.matchRegex("^1\\d{10}$")
//    }
//    
//    
//    /**
//     计算单行string的大小
//     
//     - parameter font: string被绘制的字体大小
//     
//     - returns: string的size
//     */
//    func singleLineSize(font: UIFont) -> CGSize {
//        return self.size(attributes: [NSFontAttributeName: font])
//    }
//    
//    /**
//     计算多行string的大小
//     
//     - parameter font:   string被绘制的字体大小
//     - parameter width:  string被绘制的宽度
//     - parameter height: string被绘制的最大高度
//     
//     - returns: string的size
//     */
//    func multiLineSize(font: UIFont, textWidth width: CGFloat, maxHeight height: CGFloat = 0) -> CGSize {
//        return self.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
//    }
//}
//
//// MARK: - String类型扩展
//extension String {
//    /// md5值
//    var md5: String? {
//        let nSString = NSString(string: self)
//        if let nSStringMD5 = nSString.md5 {
//            return String(nSStringMD5)
//        }
//        
//        return nil
//    }
//    
//    /// sha1值
//    var sha1: String? {
//        let nSString = NSString(string: self)
//        if let nSStringSHA1 = nSString.sha1 {
//            return String(nSStringSHA1)
//        }
//        
//        return nil
//    }
//    
//    //MARK: - 字符串正则表达式
//    /**
//    字符串是否满足正则表达式
//    
//    - parameter regex: 正则字符串
//    
//    - returns: 是否满足
//    */
//    fileprivate func matchRegex(_ regex: String) -> Bool {
//        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
//        return pred.evaluate(with: self)
//    }
//    
//    /// 字符串是否是邮件格式
//    var isEmail: Bool {
//        return self.matchRegex("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$")
//    }
//    
//    var isCellPhone: Bool {
//        return self.matchRegex("^1\\d{10}$")
//    }
//    
//    /**
//     字符串后面添加一级目录文件
//     
//     - parameter str:追加的文件或文件夹名字
//     
//     - returns: 追加后的路径
//     */
//    func stringByAppendingPathComponent(_ str: String) -> String {
//        return (self as NSString).appendingPathComponent(str)
//    }
//    
//    /**
//     字符串后面添加文件后缀
//     
//     - parameter str: 后缀名称，如:jpg
//     
//     - returns: 追加后的字符串
//     */
//    func stringByAppendingPathExtension(_ str: String) -> String? {
//        return (self as NSString).appendingPathExtension(str)
//    }
//    
//    /**
//     计算单行string的大小
//     
//     - parameter font: string被绘制的字体大小
//     
//     - returns: string的size
//     */
//    func singleLineSize(font: UIFont) -> CGSize {
//        let str = self as NSString
//        return str.size(attributes: [NSFontAttributeName: font])
//    }
//    
//    /**
//     计算多行string的大小
//     
//     - parameter font:   string被绘制的字体大小
//     - parameter width:  string被绘制的宽度
//     - parameter height: string被绘制的最大高度
//     
//     - returns: string的size
//     */
//    func multiLineSize(font: UIFont, textWidth width: CGFloat, maxHeight height: CGFloat = 0) -> CGSize {
//        let str = self as NSString
//        return str.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
//    }
//    
//    func multiLineSizeWithAttributes(textWidth width: CGFloat, maxHeight height: CGFloat = 0,attributes: [String : AnyObject]?) -> CGSize {
//        let str = self as NSString
//        return str.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
//    }
//    
//    
//    /**
//     可选字符串转化成空字符串
//     
//     - parameter str:	要转换的字符串
//     
//     - returns: 返回的字符串
//     */
//    static func safeString(_ str: String?) -> String {
//        
//        guard let string = str else { return "" }
//        return string
//    }
//    
//    
//    static func compareCurrentTime(_ compareDate: Date)->String
//    {
//    let now = Date(timeIntervalSinceNow: 8 * 60 * 60)
//    var  timeInterval = compareDate.timeIntervalSince(now)
//    timeInterval = fabs(timeInterval) ;
//    var temp = 0;
//    var  result = ""
//        
//    if (timeInterval < 60) {
//        result = "刚刚"
//        
//        return result
//    }
//        
//    temp = Int(timeInterval) / 60
//        
//   if(temp < 60){
//        result = String.init(format: "%d钟前", temp)
//    return result
//    }
//        
//    temp = temp / 60
//    
//    if(temp < 24){
//        result = String.init(format: "%d小时前", temp)
//        return result
//    }
//        
//    temp = temp / 24
//        
//    if(temp  < 30){
//    result = String.init(format: "%d天前", temp)
//        return result
//    }
//        
//    temp = temp / 30
//        
//     if( temp  < 12){
//        result = String.init(format: "%d月前", temp)
//        return result
//    }
//        
//    temp = temp / 12
//        
//    if ( temp > 0){
//        result = String.init(format: "%d年前", temp)
//        return result
//    }
//    
//    return  "";
//    }
//    
//}
//

