//
//  NSUserDefaults+Extension.swift
//  MicroShop
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Haioo. All rights reserved.
//

import UIKit

public let UserDefaults = NSUserDefaults.standardUserDefaults()

public extension NSUserDefaults {
    public subscript(key: String) -> Any? {
        get { return self.valueForKey(key) as Any }
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
        self.synchronize()
    }

    /// Is there a object for specific key exist.
    public func hasKey(key: String) -> Bool {
        return nil != self.objectForKey(key)
    }
    
    /// Archive object to NSData to save.
    public func archiveObject(object: AnyObject?, forKey key: String) {
        if let value = object {
            setter(key, NSKeyedArchiver.archivedDataWithRootObject(value))
        } else {
            self.removeObjectForKey(key)
        }
    }
    
    /// Unarchive object for specific key.
    public func unarchiveObjectForKey(key: String) -> AnyObject? {
        return self.dataForKey(key).flatMap { NSKeyedUnarchiver.unarchiveObjectWithData($0) }
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