//
//  CoreImageFilter.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 16/9/21.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit
import CoreImage

public enum Blur: String {
    case CIBoxBlur, CIDiscBlur, CIGaussianBlur, CIMaskedVariableBlur, CIMedianFilter, CIMotionBlur, CINoiseReduction, CIZoomBlur
    
}

public typealias Filter = (CIImage) -> CIImage

public func blur(blurName: String, radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [kCIInputRadiusKey: radius, kCIInputImageKey: image]
        
        guard let filter = CIFilter(name: blurName, withInputParameters: parameters) else {
            fatalError()
        }
        
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        
        return outputImage
    }
}
