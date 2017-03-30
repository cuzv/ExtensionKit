//
//  Lang+Extension.swift
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

public func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsMake(lhs.top + rhs.top, lhs.left + rhs.left, lhs.bottom + rhs.bottom, lhs.right + rhs.right)
}

/// Find out the geiven object is some type or not.
public func objectIsType<T>(_ object: Any, _ someObjectOfType: T.Type) -> Bool {
    return object is T
}

/**
 See: https://gist.githubusercontent.com/Abizern/a81f31a75e1ad98ff80d/raw/85b85cbb9bcdeb8cdbf2521ac935e3d2cb4cdd4f/loggingPrint.swift
 
 Prints the filename, function name, line number and textual representation of `object` and a newline character into
 the standard output if the build setting for "Other Swift Flags" defines `-D DEBUG`.
 
 The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
 
 Only the first parameter needs to be passed to this funtion.
 
 The textual representation is obtained from the `object` using its protocol conformances, in the following
 order of preference: `CustomDebugStringConvertible` and `CustomStringConvertible`. Do not overload this function for
 your type. Instead, adopt one of the protocols mentioned above.
 
 :param: object   The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
 :param: file     The name of the file, defaults to the current file without the ".swift" extension.
 :param: function The name of the function, defaults to the function within which the call is made.
 :param: line     The line number, defaults to the line number within the file that the call is made.
 */
public func logging<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String
        
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            stringRepresentation = "\(value)"
        }
        let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
    #endif
}

/// Get value from `any` instance like KVC
public func takeValue(from object: Any, forKey key: String) -> Any? {
    func takeValue(_ mirror: Mirror, _ key: String) -> Any? {
        for (targetKey, targetMirror) in mirror.children {
            if key == targetKey {
                return targetMirror
            }
        }
        return nil
    }
    
    func take(_ mirror: Mirror, _ key: String) -> Any? {
        if let value = takeValue(mirror, key) {
            return value
        }
        if let superMirror = mirror.superclassMirror {
            return take(superMirror, key)
        }
        return nil
    }
    
    let mirror = Mirror(reflecting: object)
    return take(mirror, key)
}

/// Generate random number in range
public func random(in range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}

// MARK: - GCD

public typealias Task = ((_ cancel: Bool) -> ())

@discardableResult
public func delay(interval time: TimeInterval, task: @escaping (() -> ())) -> Task? {
    func dispatch_later(_ block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block
        )
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

public func mainThreadAsync(execute work: @escaping () -> ()) {
    if Thread.isMainThread {
        work()
        return
    }
    DispatchQueue.main.async(execute: work)
}

public func backgroundThreadAsync(execute work: @escaping () -> ()) {
    if !Thread.isMainThread {
        work()
        return
    }
    DispatchQueue.global().async(execute: work)
}

// MARK: - synchronized

public func synchronized(lock: AnyObject, work: () -> ()) {
    objc_sync_enter(lock)
    work()
    objc_sync_exit(lock)
}

// MARK: - Method swizzle

/// Should be placed in dispatch_once
public func swizzleInstanceMethod(
    for cls: AnyClass,
    original: Selector,
    override: Selector)
{
    let originalMethod = class_getInstanceMethod(cls, original)
    let overrideMethod = class_getInstanceMethod(cls, override)
    
    if class_addMethod(
        cls,
        original,
        method_getImplementation(overrideMethod),
        method_getTypeEncoding(overrideMethod))
    {
        class_replaceMethod(
            cls,
            override,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
}

/// Should be placed in dispatch_once
public func swizzleClassMethod(
    for cls: AnyClass,
    original: Selector,
    override: Selector)
{
    let originalMethod = class_getClassMethod(cls, original)
    let overrideMethod = class_getClassMethod(cls, override)
    
    if class_addMethod(
        cls,
        original,
        method_getImplementation(overrideMethod),
        method_getTypeEncoding(overrideMethod))
    {
        class_replaceMethod(
            cls,
            override,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
}

// MARK: - C Pointers

/// Convert a `void *` type to Swift type, use this function carefully
public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return value.assumingMemoryBound(to: T.self).pointee
}

// MARK: - Sandbox

private func searchPath(for directory: FileManager.SearchPathDirectory) -> String? {
    return NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true).first
}

public func directoryForDocument() -> String? {
    return searchPath(for: .documentDirectory)
}

public func directoryForCache() -> String? {
    return searchPath(for: .cachesDirectory)
}

public func directoryForDownloads() -> String? {
    return searchPath(for: .downloadsDirectory)
}

public func directoryForMovies() -> String? {
    return searchPath(for: .moviesDirectory)
}

public func directoryForMusic() -> String? {
    return searchPath(for: .musicDirectory)
}

public func directoryForPictures() -> String? {
    return searchPath(for: .picturesDirectory)
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
    
    public func invoke(_ param: T) {
        if let closure = closure as? (() -> ()) {
            closure()
        } else if let closure = closure as? ((T) -> ()) {
            closure(param)
        }
    }
    
    deinit {
        logging("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}

// MARK: - Swifty Target & Action
// See: https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html

final public class ActionTrampoline<T>: NSObject {
    fileprivate let action: ((T) -> ())
    public var selector: Selector? {
        return NSSelectorFromString("action:")
    }
    
    public init(action: @escaping ((T) -> ())) {
        self.action = action
    }
    
    @objc public func action(_ sender: AnyObject) {
        // UIControl: add(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
        if let sender = sender as? T {
            action(sender)
        }
        // UIGestureRecognizer: add(target: AnyObject, action: Selector)
        else if let sender = sender as? UIGestureRecognizer {
            action(sender.view as! T)
        }
    }
    
    deinit {
        logging("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}

