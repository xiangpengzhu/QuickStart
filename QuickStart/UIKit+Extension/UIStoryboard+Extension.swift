//
//  UIStoryboard+Extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /**
     通过一个storyboardid生成一个ViewController
     
     - parameter sid: storyBoardId
     
     - returns: ViewController的一个实例
     */
    static func viewControllerWithStoryboardId(_ sid: String, storyBoardName: String = "Main") -> UIViewController? {
        let sb = UIStoryboard(name: storyBoardName, bundle: nil)
        return sb.instantiateViewController(withIdentifier: sid)
    }
}
