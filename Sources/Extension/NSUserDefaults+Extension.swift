//
//  NSUserDefaults+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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

public extension Foundation.UserDefaults {
    public subscript(key: String) -> Any? {
        get { return value(forKey: key) as Any }
        set {
            switch newValue {
            case let value as Int: set(value, forKey: key)
            case let value as Double: set(value, forKey: key)
            case let value as Bool: set(value, forKey: key)
            case let value as URL: set(value, forKey: key)
            case let value as NSObject: set(value, forKey: key)
            case nil: removeObject(forKey: key)
            default: assertionFailure("Invalid value type.")
            }
        }
    }
    
    fileprivate func setter(key: String, value: AnyObject?) {
        self[key] = value
        synchronize()
    }

    /// Is there a object for specific key exist.
    public func hasKey(_ key: String) -> Bool {
        return nil != object(forKey: key)
    }
    
    /// Archive object to NSData to save.
    public func archive(object: AnyObject?, forKey key: String) {
        if let value = object {
            setter(key: key, value: NSKeyedArchiver.archivedData(withRootObject: value) as AnyObject?)
        } else {
            removeObject(forKey: key)
        }
    }
    
    /// Unarchive object for specific key.
    public func unarchiveObject(forKey key: String) -> AnyObject? {
        return data(forKey: key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) as AnyObject }
    }
    
    
    /// Get the Int value for key.
    public func intValue(forKey key: String) -> Int? {
        if let value = self[key], let intValue = value as? Int {
            return intValue
        } else {
            return nil
        }
    }
    
    /// Get the Double value for key.
    public func doubleValue(forKey key: String) -> Double? {
        if let value = self[key], let doubleValue = value as? Double {
            return doubleValue
        } else {
            return nil
        }
    }
    
    /// Get the Bool value for key.
    public func boolValue(forKey key: String) -> Bool {
        if let value = self["Key"], let boolValue = value as? Bool  {
            return boolValue
        } else {
            return false
        }
    }
    
    /// Get the NSURL value for key.
    public func urlValue(forKey  key: String) -> URL? {
        if let value = self[key], let urlValue = value as? URL {
            return urlValue
        } else {
            return nil
        }
    }
    
    /// Get the NSObject value for key.
    public func objectValue(forKey key: String) -> NSObject? {
        if let value = self[key], let objectValue = value as? NSObject {
            return objectValue
        } else {
            return nil
        }
    }
}
