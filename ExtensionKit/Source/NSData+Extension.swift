//
//  NSData+Extension.swift
//  MicroShop
//
//  Created by Moch Xiao on 1/3/16.
//  Copyright © 2016 foobar. All rights reserved.
//

import Foundation

public extension NSData {
    /// Create a Foundation object from JSON data.
    public var JSONObject: AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.MutableLeaves)
        } catch let error as NSError {
            debugPrint("Deserialized JSON string failed with error: \(error)")
            return nil
        }
    }
}

/// Generate JSON data from a Foundation object
public func NSDataFromJSONObject(object: AnyObject) -> NSData? {
    do {
        return try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
    } catch let error as NSError {
        debugPrint("Serialized JSON string failed with error: \(error)")
        return nil
    }
}
