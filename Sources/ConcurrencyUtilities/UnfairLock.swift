//
//  File.swift
//  
//
//  Created by Yu Ao on 2019/12/17.
//

import Foundation

/// An `os_unfair_lock` wrapper.
public class UnfairLock {
    private let unfairLock: os_unfair_lock_t
    
    public init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
    
    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
    
    public func tryLock() -> Bool {
        return os_unfair_lock_trylock(unfairLock)
    }
    
    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    public func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try closure()
    }
    
    /// Execute a closure while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    public func around(_ closure: () throws -> Void) rethrows {
        lock(); defer { unlock() }
        return try closure()
    }
}
