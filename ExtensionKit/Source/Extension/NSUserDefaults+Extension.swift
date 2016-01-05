//
//  NSUserDefaults+Extension.swift
//  MicroShop
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Haioo. All rights reserved.
//

import Foundation

public let UserDefaults = NSUserDefaults.standardUserDefaults()

public extension NSUserDefaults {
    public subscript(key: String) -> AnyObject? {
        get { return self.valueForKey(key) }
        set {
            self.setValue(newValue, forKey: key)
            self.synchronize()
        }
    }
    
    public subscript(key: String) -> CGFloat? {
        get { return self.valueForKey(key) as? CGFloat }
        set {
            self.setValue(newValue, forKey: key)
            self.synchronize()
        }
    }
    
    public subscript(key: String) -> Int? {
        get { return self.valueForKey(key) as? Int }
        set {
            self.setValue(newValue, forKey: key)
            self.synchronize()
        }
    }
    
    public subscript(key: String) -> Bool? {
        get { return self.valueForKey(key) as? Bool }
        set {
            self.setValue(newValue, forKey: key)
            self.synchronize()
        }
    }
}