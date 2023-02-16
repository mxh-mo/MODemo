//
//  MOLocationManager.swift
//  09_MultiDelegate_Swift
//
//  Created by MikiMo on 2019/9/4.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import Foundation

protocol MOLocationManagerDelegate: NSObjectProtocol {
    func locationUpdate(_ locs:[String])
}

class MOLocationManager {
    static let shared: MOLocationManager = MOLocationManager()
    
    // 1. NSHashTable中的元素可以通过Hashable协议来判断是否相等.
    // 2. NSHashTable中的元素如果是弱引用,对象销毁后会被移除,可以避免循环引用
    private let multiDelegate: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    // MARK: - 需要代理们回调的方法
    func locationUpdate() {
        invoke{ $0.locationUpdate(["北京", "海淀"]) }
    }
    
    func add(_ delegate: MOLocationManagerDelegate) {
        multiDelegate.add(delegate)
    }
    
    func remove(_ delegate: MOLocationManagerDelegate) {
        invoke {
            if $0 === delegate as AnyObject {
                multiDelegate.remove($0)
            }
        }
    }
    
    func removeAll() {
        multiDelegate.removeAllObjects()
    }
    
    private func invoke(_ invocation: (MOLocationManagerDelegate) -> Void) {
        for delegate in multiDelegate.allObjects.reversed() {
            invocation(delegate as! MOLocationManagerDelegate)
        }
    }
}
