//
//  Nostalgia.swift
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

prefix operator ++
// @discardableResult
prefix public func ++(x: inout Int) -> Int { x += 1; return x }
// @discardableResult
prefix public func ++(x: inout UInt) -> UInt { x += 1; return x }


postfix operator ++
// @discardableResult
postfix public func ++(x: inout Int) -> Int { defer {x += 1}; return x }
// @discardableResult
postfix public func ++(x: inout UInt) -> UInt { defer {x += 1}; return x }

prefix operator --
// @discardableResult
prefix public func --(x: inout Int) -> Int { x -= 1; return x }
// @discardableResult
prefix public func --(x: inout UInt) -> UInt { x -= 1; return x }


postfix operator --
// @discardableResult
postfix public func --(x: inout Int) -> Int { defer {x -= 1}; return x }
// @discardableResult
postfix public func --(x: inout UInt) -> UInt { defer {x -= 1}; return x }

// Alternatively, deriving 1
// via Pilipenko Dima http://github.com/dimpiax
postfix operator +++
postfix public func +++<T: IntegerArithmetic>(x: inout T) -> T { defer { x += x/x }; return x }

prefix operator +++
prefix public func +++<T: IntegerArithmetic>(x: inout T) -> T { x += x/x; return x }

// CGFloat versions apparently need separate implementations
// prefix public func +++(inout x: CGFloat) -> CGFloat { defer { x += 1 }; return x }
// prefix public func +++(inout x: CGFloat) -> CGFloat { x += 1; return x }

// via "torquato"

//postfix operator ++++ {}
//postfix public func ++++<T: BidirectionalIndexType>(inout x: T) -> T { defer { x = x.successor() }; return x }
//prefix operator ++++ {}
//prefix public func ++++<T: BidirectionalIndexType>(inout x: T) -> T { x = x.successor(); return x }
//postfix operator ---- {}
//postfix public func ----<T: BidirectionalIndexType>(inout x: T) -> T { defer { x = x.predecessor() }; return x }
//prefix operator ---- {}
//prefix public func ----<T: BidirectionalIndexType>(inout x: T) -> T { x = x.predecessor(); return x }
