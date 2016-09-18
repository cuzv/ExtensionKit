//
//  Number+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
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

// MARK: - Double -> String

public extension Double {
    public var price:  String {
        let str = String(format: "%.2f", self)
        if str.hasSuffix("00") {
            return String(format: "%.0f", self)
        }
        if str.hasSuffix("0") {
            return String(format: "%.1f", self)
        }
        return str
    }
    public var CNYString: String {
        return "¥" + price
    }

    public var CNYShortString: String {
        return String(format: "¥%.0f", self)
    }

    public var USDString: String {
        return "$" + price
    }
    
    public var USDShortString: String {
        return String(format: "$%.0f", self)
    }
    
    public var string: String {
        return String(self)
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
}
