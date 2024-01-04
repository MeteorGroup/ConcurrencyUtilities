//
//  File.swift
//  
//
//  Created by Yu Ao on 2019/12/17.
//

import Foundation

extension DispatchQueue {
    public static func dispatchSyncOnMainQueue(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
    
    public static func dispatchAsyncOnMainQueue(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
