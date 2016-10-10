//
//  UIScreen+extension.swift
//  LibTest
//
//  Created by zxp on 15/10/20.
//  Copyright © 2015年 zxp. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /**
     计算一个size在设备上对应的大小
     比如320 在iphone 5s上面是320 在iphone6上面就是375
     
     - parameter pixel: 点值
     
     - returns: 本设备对应的大小
     */
    public func systemPixel(_ pixel: CGFloat) -> CGFloat {
        let origin: CGFloat = 320.0;
        let screen = self.bounds.size.width;
        return pixel * screen / origin;
    }
    
    
    /// 动效设置屏幕亮度
    ///
    /// - parameter value:    亮度
    /// - parameter animated: 是否有动画
    public func setBrightness(value: CGFloat, animated: Bool) {
        if animated {
            _brightnessQueue.cancelAllOperations()
            let step: CGFloat = 0.005 * ((value > brightness) ? 1 : -1)
            _brightnessQueue.addOperations(stride(from: brightness, through: value, by: step).map({ [weak self] value -> Operation in
                let blockOperation = BlockOperation()
                unowned let _unownedOperation = blockOperation
                blockOperation.addExecutionBlock({
                    if !_unownedOperation.isCancelled {
                        Thread.sleep(forTimeInterval: 1 / 10000.0)
                        self?.brightness = value
                    }
                })
                return blockOperation
                }), waitUntilFinished: false)
        } else {
            brightness = value
        }
    }
}


private let _brightnessQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()
