//
//  Dictionary+Extension.swift
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

// MARK: - Dictionary

public extension Dictionary {
    /// URL query string.
    public var queryString: String {
        let mappedList = map {
            return "\($0.0)=\($0.1)"
        }
        return mappedList.sorted().joined(separator: "&")
    }
    
    public var JSONString: String? {
        if let data = Data.make(fromJSONObject: self as AnyObject) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

/// Combine two `Dictionary` to one.
public func += <KeyType, ValueType> (lhs: inout Dictionary<KeyType, ValueType>, rhs: Dictionary<KeyType, ValueType>) {
    for (key, value) in rhs {
        lhs.updateValue(value, forKey: key)
    }
}

