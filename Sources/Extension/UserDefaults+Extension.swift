//
//  UserDefaults+Extension.swift
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

import UIKit

public let UserDefaults = Foundation.UserDefaults.standard

public extension Extension where Base: Foundation.UserDefaults {
    public subscript(key: String) -> Any? {
        get { return base.value(forKey: key) as Any }
        set {
            switch newValue {
            case let value as Int: base.set(value, forKey: key)
            case let value as Double: base.set(value, forKey: key)
            case let value as Bool: base.set(value, forKey: key)
            case let value as URL: base.set(value, forKey: key)
            case let value as NSObject: base.set(value, forKey: key)
            case nil: base.removeObject(forKey: key)
            default: assertionFailure("Invalid value type.")
            }
        }
    }
    
    fileprivate func setter(key: String, value: AnyObject?) {
        base.set(value, forKey: key)
        base.synchronize()
    }

    /// Is there a object for specific key exist.
    public func hasKey(_ key: String) -> Bool {
        return nil != base.object(forKey: key)
    }
    
    /// Archive object to NSData to save.
    public func archive(object: AnyObject?, forKey key: String) {
        if let value = object {
            setter(key: key, value: NSKeyedArchiver.archivedData(withRootObject: value) as AnyObject?)
        } else {
            base.removeObject(forKey: key)
        }
    }
    
    /// Unarchive object for specific key.
    public func unarchivedObject(forKey key: String) -> AnyObject? {
        return base.data(forKey: key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) as AnyObject }
    }
}
