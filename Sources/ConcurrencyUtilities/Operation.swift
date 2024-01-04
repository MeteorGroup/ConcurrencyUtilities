//
//  File.swift
//  
//
//  Created by Yu Ao on 2019/12/23.
//

import Foundation

extension OperationQueue {
    public convenience init(name: String, maxConcurrentOperations count: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        self.init()
        
        self.name = name
        self.maxConcurrentOperationCount = count
    }
}

extension OperationQueue {
    public static func serialQueue() -> OperationQueue {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }
    
    public static func serialQueue(named name: String) -> OperationQueue {
        return OperationQueue(name: name)
    }
}
