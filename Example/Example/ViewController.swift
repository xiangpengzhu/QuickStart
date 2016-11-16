//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit
import QuickStart
import CoreImage

class BaseModel: QSDictionaryAutoParseModel {
    private(set) var code: Int = 0
    private(set) var msg: String = ""
    
}

class RegisterResponse: BaseModel {
    var data = AppLoginUserInfo()
}

class AppLoginUserInfo: QSDictionaryAutoParseModel, NSCoding {
    
    private(set) var phone_num = ""
    private(set) var nick_name = ""
    private(set) var face_url = ""
    private(set) var token = ""
    private(set) var token_expire = 0
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        phone_num = String.safeString(aDecoder.decodeObject(forKey: "phone_num") as? String)
        nick_name = String.safeString(aDecoder.decodeObject(forKey: "nick_name") as? String)
        face_url = String.safeString(aDecoder.decodeObject(forKey: "face_url") as? String)
        token = String.safeString(aDecoder.decodeObject(forKey: "token") as? String)
        token_expire = aDecoder.decodeInteger(forKey: "token_expire")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(phone_num, forKey: "phone_num")
        aCoder.encode(nick_name, forKey: "nick_name")
        aCoder.encode(face_url, forKey: "face_url")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(token_expire, forKey: "token_expire")
    }
}

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic = ["code": 100, "msg": "hell", "data": NSNull()] as [String : Any]
        let resp = RegisterResponse()
        let result = resp.parse(fromJsonObject: dic) {
            type in
            if type == "AppLoginUserInfo" {
                return AppLoginUserInfo()
            }
            return nil
        }
        
        print(resp)
    }
}

