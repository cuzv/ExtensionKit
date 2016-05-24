//
//  CGD.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 5/4/16.
//  Copyright © 2016 Moch. All rights reserved.
//

// See: http://khanlou.com/2016/04/the-GCD-handbook/
import Foundation

private let serial_queue_label = "com.mochxiao.queue.serial"
private let concurrent_queue_label = "com.mochxiao.queue.concurrent"
private let isolation_queue_label = "com.mochxiao.isolation.queue"

public class AsyncSerialWorker {
    public init() {}
    private let serialQueue = dispatch_queue_create(serial_queue_label, DISPATCH_QUEUE_SERIAL)
    
    public func enqueueWork(work: (() -> ()) -> ()) {
        dispatch_async(serialQueue) {
            let semaphore = dispatch_semaphore_create(0)
            work {
                dispatch_semaphore_signal(semaphore)
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
    }
}

public class LimitedWorker {
    private let concurrentQueue = dispatch_queue_create(concurrent_queue_label, DISPATCH_QUEUE_CONCURRENT)
    private let semaphore: dispatch_semaphore_t
    
    public init(limit: Int) {
        semaphore = dispatch_semaphore_create(limit)
    }
    
    public func enqueueWork(work: () -> ()) {
        dispatch_async(concurrentQueue) {
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            work()
            dispatch_semaphore_signal(self.semaphore)
        }
    }
}

public protocol Identifiable {
    var identifier: String { get }
}

extension Identifiable {
    var identifier: String { return NSUUID().UUIDString }
}

extension NSObject: Identifiable {
    public var identifier: String { return "\(hash)" }
}

public class IdentityMap<T: Identifiable> {
    var dictionary = [String: T]()
    let accessQueue = dispatch_queue_create(isolation_queue_label, DISPATCH_QUEUE_CONCURRENT)
    
    func objectWithIdentifier(identifier: String) -> T? {
        var result: T? = nil
        dispatch_sync(accessQueue) {
            result = self.dictionary[identifier] as T?
        }
        return result
    }
    
    func addObject(object: T) {
        dispatch_barrier_async(accessQueue) {
            self.dictionary[object.identifier] = object
        }
    }
}
