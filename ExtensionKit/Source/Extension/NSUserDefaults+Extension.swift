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

public let UserDefaults = NSUserDefaults.standardUserDefaults()

public extension NSUserDefaults {
    public subscript(key: String) -> Any? {
        get { return valueForKey(key) as Any }
        set {
            switch newValue {
            case let value as Int: setInteger(value, forKey: key)
            case let value as Double: setDouble(value, forKey: key)
            case let value as Bool: setBool(value, forKey: key)
            case let value as NSURL: setURL(value, forKey: key)
            case let value as NSObject: setObject(value, forKey: key)
            case nil: removeObjectForKey(key)
            default: assertionFailure("Invalid value type.")
            }
        }
    }
    
    private func setter(key: String, _ value: AnyObject?) {
        self[key] = value
        synchronize()
    }

    /// Is there a object for specific key exist.
    public func hasKey(key: String) -> Bool {
        return nil != objectForKey(key)
    }
    
    /// Archive object to NSData to save.
    public func archiveObject(object: AnyObject?, forKey key: String) {
        if let value = object {
            setter(key, NSKeyedArchiver.archivedDataWithRootObject(value))
        } else {
            removeObjectForKey(key)
        }
    }
    
    /// Unarchive object for specific key.
    public func unarchiveObjectForKey(key: String) -> AnyObject? {
        return dataForKey(key).flatMap { NSKeyedUnarchiver.unarchiveObjectWithData($0) }
    }
    
    
    /// Get the Int value for key.
    public func intValueForKey(key: String) -> Int? {
        if let value: Any? = self[key], let intValue = value as? Int {
            return intValue
        } else {
            return nil
        }
    }
    
    /// Get the Double value for key.
    public func doubleValueForKey(key: String) -> Double? {
        if let value: Any? = self[key], let doubleValue = value as? Double {
            return doubleValue
        } else {
            return nil
        }
    }
    
    /// Get the Bool value for key.
    public func boolValueForKey(key: String) -> Bool {
        if let value: Any? = self["Key"], let boolValue = value as? Bool  {
            return boolValue
        } else {
            return false
        }
    }
    
    /// Get the NSURL value for key.
    public func urlValueForKey(key: String) -> NSURL? {
        if let value: Any? = self[key], let urlValue = value as? NSURL {
            return urlValue
        } else {
            return nil
        }
    }
    
    /// Get the NSObject value for key.
    public func objectValueForKey(key: String) -> NSObject? {
        if let value: Any? = self[key], let objectValue = value as? NSObject {
            return objectValue
        } else {
            return nil
        }
    }
}