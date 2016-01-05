//
//  NSObject+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/30/15.
//  Copyright © @2015 Moch Xiao (https://github.com/cuzv).
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

// MARK: - Associate Object

public extension NSObject {
    /// Sets an associated value for a given object using a weak reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    public func associateAssignObject(object: AnyObject!, forKey key: UnsafePointer<Void>) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValueForKey(strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
        didChangeValueForKey(strKey)
    }

    /// Sets an associated value for a given object using a strong reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    public func associateRetainObject(object: AnyObject!, forKey key: UnsafePointer<Void>) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValueForKey(strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValueForKey(strKey)
    }

    /// Sets an associated value for a given object using a copied reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    public func associateCopyObject(object: AnyObject!, forKey key: UnsafePointer<Void>) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValueForKey(strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        didChangeValueForKey(strKey)
    }
    
    /// Returns the value associated with a given object for a given key.
    /// **Note**: the `key` underlying type must be String.
    public func associatedObjectForKey(key: UnsafePointer<Void>) -> AnyObject! {
        return objc_getAssociatedObject(self, key)
    }
}