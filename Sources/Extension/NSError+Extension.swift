//
//  NSError+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/26/15.
//  Copyright © 2015 Moch Xiao (https://github.com/cuzv).
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

public extension NSError {
    public class func errorWithMessage(_ message: String) -> NSError {
        return NSError(domain: "com.mochxiao.error.maker", code: 999, userInfo: [NSLocalizedDescriptionKey: message, NSLocalizedFailureReasonErrorKey: message])
    }
    
    public class func empty() -> NSError {
        return NSError(domain: emptyErrorDomain, code: emptyErrorCode, userInfo: nil)
    }
    
    public static var emptyErrorDomain: String { return "com.mochxiao.error.default" }
    public static var emptyErrorCode: Int { return 1024 }
}

public func NSErrorFrom(_ message: String) -> NSError {
    return NSError.errorWithMessage(message)
}

