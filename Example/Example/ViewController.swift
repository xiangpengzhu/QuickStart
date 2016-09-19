//
//  ViewController.swift
//  Example
//
//  Created by zhu on 16/9/16.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit
import QuickStart


class ViewController: UIViewController {
    
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        QSDynamicFontManager.default.bind(dynamicFontView: label, dynamicFontSytle: .body)
        QSDynamicFontManager.default.bind(dynamicFontView: button, dynamicFontSytle: .subheadline)
        QSDynamicFontManager.default.bind(dynamicFontView: textField, dynamicFontSytle: .headline)
        QSDynamicFontManager.default.bind(dynamicFontView: textView, dynamicFontSytle: .footnote)
    }
}

