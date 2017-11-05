//
//  ExtensionProtocols.swift
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

// See: http://ericasadun.com/2016/04/18/default-reflection/
/// A reference type that provides a better default representation than the class name.
public protocol DefaultReflectable: CustomStringConvertible {}

/// A default implementation that enables class members to display their values.
extension DefaultReflectable {
    /// Constructs a better representation using reflection.
    internal func defaultDescription<T>(_ instance: T) -> String {
        let mirror = Mirror(reflecting: instance)
        let chunks = mirror.children.map { (label: String?, value: Any) -> String in
            if let label = label {
                if value is String {
                    return "\(label): \"\(value)\""
                }
                return "\(label): \(value)"
            } else {
                return "\(value)"
            }
        }
        if chunks.count > 0 {
            let chunksString = chunks.joined(separator: ", ")
            return "\(mirror.subjectType)(\(chunksString))"
        } else {
            return "\(instance)"
        }
    }
    
    /// Conforms to CustomStringConvertible.
    public var description: String {
        return defaultDescription(self)
    }
}
//
//extension NSObject: DefaultReflectable {
//}

