//
//  Dictionary+Extension.swift
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

// MARK: - Dictionary

public extension Dictionary {
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((key.escaped, (value.boolValue ? "1" : "0").escaped))
            } else {
                components.append((key.escaped, "\(value)".escaped))
            }
        } else if let bool = value as? Bool {
            components.append((key.escaped, (bool ? "1" : "0").escaped))
        } else {
            components.append((key.escaped, "\(value)".escaped))
        }
        
        return components
    }
    
    /// Stolen from Alamofire
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    public var queryString: String {
        var newDic: [String: Any] = [:]
        for element in self {
            newDic["\(element.key)"] = element.value
        }
        return query(newDic)
    }
    
    public var JSONString: String? {
        if let data = Data.make(fromJSONObject: self as AnyObject) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

/// Combine two `Dictionary` to one.
public func += <KeyType, ValueType>(
    lhs: inout Dictionary<KeyType, ValueType>,
    rhs: Dictionary<KeyType, ValueType>)
{
    for (key, value) in rhs {
        lhs.updateValue(value, forKey: key)
    }
}

