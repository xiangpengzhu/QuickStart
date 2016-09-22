//
//  SecondViewController.swift
//  Example
//
//  Created by zhu on 16/9/22.
//  Copyright © 2016年 xpz. All rights reserved.
//

import UIKit

let secondViewParamId = "SecondViewController.id"
let secondViewParamName = "SecondViewController.name"

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let id = self.parameter?[secondViewParamId] {
            print(id)
        }
        
        if let name = self.parameter?[secondViewParamName] {
            print(name)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
