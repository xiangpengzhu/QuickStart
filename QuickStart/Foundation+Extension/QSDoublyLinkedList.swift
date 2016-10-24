//
//  QSDoublyLinkedList.swift
//  QuickStart
//
//  Created by zhuxiangpeng on 2016/10/24.
//  Copyright © 2016年 zxp. All rights reserved.
//

import UIKit


/// 双向链表节点
public class QSDoublyLinkedNode<T>: NSObject {
    public var value: T?
    public var forward: QSDoublyLinkedNode<T>?
    public var behind: QSDoublyLinkedNode<T>?
}

/// 双向链表
public class QSDoublyLinkedList<T>: NSObject {

    public var rootNode: QSDoublyLinkedNode<T> {
        return _rootNode
    }
    
    private var _rootNode: QSDoublyLinkedNode<T>
    public init(rootValue: T) {
        _rootNode = QSDoublyLinkedNode<T>()
        super.init()
        _rootNode.value = rootValue
    }
    
    public func insertValue(value: T, beforeNode node: QSDoublyLinkedNode<T>) -> QSDoublyLinkedNode<T> {
        let newNode = QSDoublyLinkedNode<T>()
        newNode.value = value
        newNode.forward = node.forward
        newNode.behind = node
        
        node.forward?.behind = newNode
        node.forward = newNode
        
        return newNode
    }
    
    public func insertValue(value: T, afterNode node: QSDoublyLinkedNode<T>) -> QSDoublyLinkedNode<T> {
        let newNode = QSDoublyLinkedNode<T>()
        newNode.value = value
        newNode.forward = node
        newNode.behind = node.behind
        
        node.behind?.forward = newNode
        node.behind = newNode
        
        return newNode
    }
    
    deinit {
        
        _rootNode.value = nil
        
        var next = _rootNode.behind
        while next != nil {
            next?.value = nil
            next?.forward = nil
            
            var tmp = next
            next = next?.behind
            
            tmp?.behind = nil
        }
        
        var previous = _rootNode.forward
        while previous != nil {
            previous?.value = nil
            previous?.behind = nil
            
            var tmp = previous
            previous = previous?.forward
            tmp?.forward = nil
        }
        
        _rootNode.behind = nil
        _rootNode.forward = nil
    }
}
