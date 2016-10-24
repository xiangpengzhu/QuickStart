//
//  QSMVPPresenter.swift
//  eBook
//
//  Created by zhuxiangpeng on 2016/10/20.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit

@objc public protocol QSMVPPresenter: NSObjectProtocol {
    
    init(view: QSMVPView)
    
    @objc optional func viewDidLoad()
    
    @objc optional func viewWillAppear(_ animated: Bool)
    @objc optional func viewDidAppear(_ animated: Bool)
    
    @objc optional func viewWillDisappear(_ animated: Bool)
    @objc optional func viewDidDisappear(_ animated: Bool)
}
