//
//  File.swift
//  
//
//  Created by Yu Ao on 2019/12/17.
//

import Foundation
import ObjectiveC

/// Once is an object that will perform exactly one action.
public class Once {
    private var lock = UnfairLock()
    private var oncer = false
    public init() {}
    public func perform(_ action: () -> Void) {
        lock.lock()
        guard oncer == false else {
            lock.unlock()
            return
        }
        oncer = true
        lock.unlock()
        action()
    }
}

public protocol InstanceScopePerformOnce: class {
    func performOnce<T>(token: T, action: () -> Void) where T: Hashable
}

public enum InstanceScopePerformOnceToken {
    case selfObjectIdentifier
    case fileAndLine
    case custom(AnyHashable)
}

private class OncePerformer {
    private var onceObjects: [AnyHashable: Bool] = [:]
    private let lock = UnfairLock()
    func performOnce<T>(token: T, action: () -> Void) where T: Hashable {
        var shouldPerform = false
        lock.around {
            if onceObjects[token, default: false] == false {
                shouldPerform = true
                onceObjects[token] = true
            }
        }
        if shouldPerform {
            action()
        }
    }
    static let creationLock = UnfairLock()
    struct FileAndLineToken: Hashable {
        let file: String
        let line: UInt
    }
}

private struct PerformOnceAssociatedKeys {
    static var oncePerformer: UInt8 = 0
}

extension InstanceScopePerformOnce {
    private var performer: OncePerformer? {
        return objc_getAssociatedObject(self, &PerformOnceAssociatedKeys.oncePerformer) as? OncePerformer
    }
    
    public func performOnce<T>(token: T, action: () -> Void) where T: Hashable {
        let performer: OncePerformer
        if let p = self.performer {
            performer = p
        } else {
            OncePerformer.creationLock.lock()
            if let p = self.performer {
                performer = p
            } else {
                performer = OncePerformer()
                objc_setAssociatedObject(self, &PerformOnceAssociatedKeys.oncePerformer, performer, .OBJC_ASSOCIATION_RETAIN)
            }
            OncePerformer.creationLock.unlock()
        }
        performer.performOnce(token: token, action: action)
    }
    
    public func performOnce(file: StaticString = #file, line: UInt = #line, token: InstanceScopePerformOnceToken, action: () -> Void) {
        switch token {
        case .fileAndLine:
            self.performOnce(token: OncePerformer.FileAndLineToken(file: "\(file)", line: line), action: action)
        case .selfObjectIdentifier:
            self.performOnce(token: ObjectIdentifier(self), action: action)
        case .custom(let t):
            self.performOnce(token: t, action: action)
        }
    }
}

extension NSObject: InstanceScopePerformOnce {
    
}
