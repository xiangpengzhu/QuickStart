//
//  BaseCell.swift
//  ShuFaHui-iOS
//
//  Created by zhuxiangpeng on 2016/11/18.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit


/// cellModel 实现的协议
@objc protocol CellModelProtocol {
    //cell 的id
    var identifier: String { get }
    
    //固定高度的cell的高度
    @objc optional var cellHeight: CGFloat { get }
    
    //动态高度，根据内容和宽度计算高度
    @objc optional func cellHeight(withWidth width: CGFloat) -> CGFloat
    
    //动态高度，autolayout计算高度
    @objc optional func cellHeight(withTableView tableView: UITableView) -> CGFloat
    
    //table didSelect 回调
    @objc optional var action: (()->Void) { get set }
    
    
    /// 记录model对应的cell
    @objc optional weak var cell: CellProtocol? { get set }
}


/// cell实现的协议
@objc protocol CellProtocol {
    @objc optional func configureCell(withModel model: CellModelProtocol)
}
