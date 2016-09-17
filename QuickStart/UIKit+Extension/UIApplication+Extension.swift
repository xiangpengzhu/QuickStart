//
//  UIApplication+extension.swift
//  ShuFaLibrary
//
//  Created by zhu on 15/10/17.
//  Copyright © 2015年 xpz. All rights reserved.
//

import UIKit

// MARK: - UIApplication通用扩展
extension UIApplication {

    //MARK: - 应用版本等
    /// app版本
    public var appVersion: String {
        get {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return ""}
            guard let dic = NSDictionary(contentsOfFile: path) else {return ""}
            guard let verObj = dic.object(forKey: "CFBundleShortVersionString") else {return ""}
            guard let ver = verObj as? String else {return ""}
            return ver
        }
    }
    
    /// app显示名称
    var appDisplayName: String {
        get {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return ""}
            guard let dic = NSDictionary(contentsOfFile: path) else {return ""}
            guard let verObj = dic.object(forKey: "CFBundleDisplayName") else {return ""}
            guard let ver = verObj as? String else {return ""}
            return ver
        }
    }
    
    /// app bundle id
    var appBundleId: String {
        get {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return ""}
            guard let dic = NSDictionary(contentsOfFile: path) else {return ""}
            guard let verObj = dic.object(forKey: "CFBundleIdentifier") else {return ""}
            guard let ver = verObj as? String else {return ""}
            return ver
        }
    }
    
    /// app bundle name
    var appBundleName: String {
        get {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return ""}
            guard let dic = NSDictionary(contentsOfFile: path) else {return ""}
            guard let verObj = dic.object(forKey: "CFBundleName") else {return ""}
            guard let ver = verObj as? String else {return ""}
            return ver
        }
    }
}
