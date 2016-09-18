//
//  Lang+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 11/16/15.
//  Copyright © 2015 Moch Xiao (https://github.com/cuzv).
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

/// Find out the geiven object is some type or not.
public func objectIsType<T>(_ object: Any, someObjectOfType: T.Type) -> Bool {
    return object is T
}

/// Log func.
public func log<T>(_ message: T,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}

/// Get value from `any` instance like KVC
public func valueFrom(_ object: Any, forKey key: String) -> Any? {
    let mirror = Mirror(reflecting: object)
    
    for (targetKey, targetMirror) in mirror.children {
        if key == targetKey {
            return targetMirror
        }
    }
    
    return nil
}

/// Generate random number in range
public func randomIn(_ range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}


// MARK: - GCD

public typealias Task = ((_ cancel: Bool) -> ())

public func delay(_ time: TimeInterval, task: @escaping (() -> ())) -> Task? {
    func dispatch_later(_ block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    var closure: (() -> ())? = task
    var result: Task?
    
    let delayedClosure: Task = {
        if let internalClosure = closure {
            if $0 == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
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

public func UIThreadAsyncAction(_ block: @escaping ()->()) {
    if Thread.isMainThread {
        block()
        return
    }
    DispatchQueue.main.async(execute: block)
}

public func BackgroundThreadAsyncAction(_ block: @escaping ()->()) {
    if !Thread.isMainThread {
        block()
        return
    }
    DispatchQueue.global().async(execute: block)
}

// MARK: - synchronized

public func synchronized(_ lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

// MARK: - Method swizzle

/// Should be placed in dispatch_once
public func swizzleInstanceMethod(forClass cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let originalMethod = class_getInstanceMethod(cls, originalSelector)
    let overrideMethod = class_getInstanceMethod(cls, overrideSelector)
    
    if class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
}

/// Should be placed in dispatch_once
public func swizzleClassMethod(forClass cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let originalMethod = class_getClassMethod(cls, originalSelector)
    let overrideMethod = class_getClassMethod(cls, overrideSelector)
    
    if class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
}

// MARK: - C Pointers

/// Convert a `void *` type to Swift type, use this function carefully
public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return unsafeBitCast(value, to: UnsafePointer<T>.self).pointee
}

// MARK: - Sandbox

private func searchPathForDirectory(_ directory: FileManager.SearchPathDirectory) -> String? {
    return NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true).first
}

public func directoryForDocument() -> String? {
    return searchPathForDirectory(.documentDirectory)
}

public func directoryForCache() -> String? {
    return searchPathForDirectory(.cachesDirectory)
}

public func directoryForDownloads() -> String? {
    return searchPathForDirectory(.downloadsDirectory)
}

public func directoryForMovies() -> String? {
    return searchPathForDirectory(.moviesDirectory)
}

public func directoryForMusic() -> String? {
    return searchPathForDirectory(.musicDirectory)
}

public func directoryForPictures() -> String? {
    return searchPathForDirectory(.picturesDirectory)
}

// MARK: - ClosureDecorator

/// ClosureDecorator, make use closure like a NSObject, aka objc_asscoiateXXX.
final public class ClosureDecorator<T>: NSObject {
    fileprivate let closure: Any
    
    fileprivate override init() {
        fatalError("Use init(action:) instead.")
    }
    
    public init(_ closure: @escaping (() -> ())) {
        self.closure = closure
    }
    
    public init(_ closure: @escaping ((T) -> ())) {
        self.closure = closure
    }
    
    func invoke(_ param: T) {
        if let closure = closure as? (() -> ()) {
            closure()
        } else if let closure = closure as? ((T) -> ()) {
            closure(param)
        }
    }
}
