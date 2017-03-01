//
//  Number+Extension.swift
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

public extension NSNumber {
    public var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

// MARK: - Double -> String

public extension Double {
    public var price: String {
        let str = String(format: "%.2f", self)
        if str.hasSuffix("00") {
            return String(format: "%.0f", self)
        }
        if str.hasSuffix("0") {
            return String(format: "%.1f", self)
        }
        return str
    }
    public var CNY: String {
        return "¥" + price
    }

    public var USD: String {
        return "$" + price
    }
    
    public var string: String {
        return String(self)
    }
    
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

// MARK: - Time & Date

public extension Double {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }

    var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }
}

public extension Int {
    var formattedDate: String {
        return Double(self).formattedDate
    }

    var formattedTime: String {
        return Double(self).formattedTime
    }
    
    var formattedDateTime: String {
        return Double(self).formattedDateTime
    }
    
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt {
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt8 {
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt16 {
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt32 {
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt64 {
    public var cgfloat: CGFloat {
        return CGFloat(self)
    }
}
