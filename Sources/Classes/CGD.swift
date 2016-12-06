//
//  CGD.swift
//  Copyright (c) 2015-2016 Moch Xiao (http://mochxiao.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

private let serial_queue_label = "com.mochxiao.queue.serial"
private let concurrent_queue_label = "com.mochxiao.queue.concurrent"
private let isolation_queue_label = "com.mochxiao.isolation.queue"

open class AsyncSerialWorker {
    public init() {}
    fileprivate let serialQueue = DispatchQueue(
        label: serial_queue_label,
        attributes: []
    )
    
    open func enqueue(work: @escaping (@escaping () -> ()) -> ()) {
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
    fileprivate let concurrentQueue = DispatchQueue(
        label: concurrent_queue_label,
        attributes: DispatchQueue.Attributes.concurrent
    )
    fileprivate let semaphore: DispatchSemaphore
    
    public init(limit: Int) {
        semaphore = DispatchSemaphore(value: limit)
    }
    
    open func enqueue(work: @escaping () -> ()) {
        concurrentQueue.async {
            _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
            work()
            self.semaphore.signal()
        }
    }
}

open class IdentityMap<T: Identifiable> {
    var dictionary = [String: T]()
    let accessQueue = DispatchQueue(
        label: isolation_queue_label,
        attributes: DispatchQueue.Attributes.concurrent
    )
    
    func object(withIdentifier identifier: String) -> T? {
        var result: T? = nil
        accessQueue.sync {
            result = self.dictionary[identifier] as T?
        }
        return result
    }
    
    func add(_ object: T) {
        accessQueue.async(flags: .barrier) {
            self.dictionary[object.identifier] = object
        }
    }
}
