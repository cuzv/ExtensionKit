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

open class AsyncSerialWorker {
    public init() {}
    fileprivate let serialQueue = DispatchQueue(label: serial_queue_label, attributes: [])
    
    open func enqueueWork(_ work: @escaping (() -> ()) -> ()) {
        serialQueue.async {
            let semaphore = DispatchSemaphore(value: 0)
            work {
                semaphore.signal()
            }
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
    }
}

open class LimitedWorker {
    fileprivate let concurrentQueue = DispatchQueue(label: concurrent_queue_label, attributes: DispatchQueue.Attributes.concurrent)
    fileprivate let semaphore: DispatchSemaphore
    
    public init(limit: Int) {
        semaphore = DispatchSemaphore(value: limit)
    }
    
    open func enqueueWork(_ work: @escaping () -> ()) {
        concurrentQueue.async {
            _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
            work()
            self.semaphore.signal()
        }
    }
}

open class IdentityMap<T: Identifiable> {
    var dictionary = [String: T]()
    let accessQueue = DispatchQueue(label: isolation_queue_label, attributes: DispatchQueue.Attributes.concurrent)
    
    func objectWithIdentifier(_ identifier: String) -> T? {
        var result: T? = nil
        accessQueue.sync {
            result = self.dictionary[identifier] as T?
        }
        return result
    }
    
    func addObject(_ object: T) {
        accessQueue.async(flags: .barrier, execute: {
            self.dictionary[object.identifier] = object
        }) 
    }
}
