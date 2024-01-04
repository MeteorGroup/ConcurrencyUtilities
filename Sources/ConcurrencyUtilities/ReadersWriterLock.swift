//
//  File.swift
//  
//
//  Created by Yu Ao on 2019/12/17.
//

import Foundation

private extension Collection {
    var nonEmpty: Self? {
        if self.count == 0 {
            return nil
        }
        return self
    }
}

public class ReadersWriterLock {
    
    private let queue: DispatchQueue
    private let qos: DispatchQoS
    
    public init(name: String? = nil, qos: DispatchQoS = .default) {
        self.qos = qos
        self.queue = DispatchQueue(label: "ConcurrencyUtilities.ReadersWriterLock.Queue-\(name?.nonEmpty ?? "Unnamed")", qos: qos, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    }
    
    public func read<T>(_ closure: () throws -> T) rethrows -> T {
        try self.queue.sync(execute: closure)
    }
    
    public func write(_ closure: () throws -> Void) rethrows {
        try self.queue.sync(flags: .barrier, execute: closure)
    }
}

