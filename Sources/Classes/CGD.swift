//
//  CGD.swift
//  Copyright (c) 2015-2016 Red Rain (http://mochxiao.com).
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

// MARK: - Delay Task & Cancel

public typealias Task = ((_ cancel: Bool) -> ())

@discardableResult
public func delay(interval time: TimeInterval, task: @escaping (() -> ())) -> Task? {
    func dispatch_later(_ block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + time,
            execute: block
        )
    }
    
    var closure: (() -> ())? = task
    var result: Task?
    
    let delayedClosure: Task = {
        if let internalClosure = closure, !$0 {
            DispatchQueue.main.async(execute: internalClosure)
        }
        
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

public func cancel(_ task: Task?) {
    task?(true)
}

// MARK: - Async Task

public func mainThreadAsync(execute work: @escaping () -> ()) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}

public func globalThreadAsync(execute work: @escaping () -> ()) {
    if !Thread.isMainThread {
        work()
    } else {
        DispatchQueue.global().async(execute: work)
    }
}

// MARK: - AsyncSerialWorker

open class AsyncSerialWorker {
    private let serialQueue = DispatchQueue(label: "com.mochxiao.queue.serial")
    
    open func enqueue(work: @escaping (@escaping () -> ()) -> ()) {
        serialQueue.async {
            let semaphore = DispatchSemaphore(value: 0)
            work { semaphore.signal() }
            semaphore.wait()
        }
    }
}

// MARK: - LimitedWorker

open class LimitedWorker {
    fileprivate let concurrentQueue = DispatchQueue(label: "com.mochxiao.queue.concurrent", attributes: .concurrent)
    fileprivate let semaphore: DispatchSemaphore
    
    public init(limit: Int) {
        semaphore = DispatchSemaphore(value: limit)
    }
    
    open func enqueue(work: @escaping () -> ()) {
        concurrentQueue.async {
            self.semaphore.wait()
            work()
            self.semaphore.signal()
        }
    }
}

// MARK: - IdentityMap

public protocol Identifiable {
    var identifier: String { get }
}

extension Identifiable {
    var identifier: String { return UUID().uuidString }
}

extension NSObject: Identifiable {
    public var identifier: String { return String(hash) }
}

open class IdentityMap<T: Identifiable> {
    var dictionary = [String: T]()
    let accessQueue = DispatchQueue(label: "com.mochxiao.isolation.queue", attributes: .concurrent)
    
    open subscript(identifier: String) -> T? {
        var result: T? = nil
        accessQueue.sync { result = self.dictionary[identifier] as T? }
        return result
    }
    
    func add(_ object: T) {
        accessQueue.async(flags: .barrier) {
            self.dictionary[object.identifier] = object
        }
    }
}

