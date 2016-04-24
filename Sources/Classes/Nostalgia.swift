//
//  Nostalgia.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 4/24/16.
//  Copyright © ericasadun.com. All rights reserved.
//

/*
 ericasadun.com
 Sometimes letting go doesn't mean saying goodbye
 */

import Foundation

prefix operator ++ {}
// @discardableResult
prefix public func ++(inout x: Int) -> Int { x += 1; return x }
// @discardableResult
prefix public func ++(inout x: UInt) -> UInt { x += 1; return x }


postfix operator ++ {}
// @discardableResult
postfix public func ++(inout x: Int) -> Int { defer {x += 1}; return x }
// @discardableResult
postfix public func ++(inout x: UInt) -> UInt { defer {x += 1}; return x }

prefix operator -- {}
// @discardableResult
prefix public func --(inout x: Int) -> Int { x -= 1; return x }
// @discardableResult
prefix public func --(inout x: UInt) -> UInt { x -= 1; return x }


postfix operator -- {}
// @discardableResult
postfix public func --(inout x: Int) -> Int { defer {x -= 1}; return x }
// @discardableResult
postfix public func --(inout x: UInt) -> UInt { defer {x -= 1}; return x }

// Alternatively, deriving 1
// via Pilipenko Dima http://github.com/dimpiax
postfix operator +++ {}
postfix public func +++<T: IntegerArithmeticType>(inout x: T) -> T { defer { x += x/x }; return x }

prefix operator +++ {}
prefix public func +++<T: IntegerArithmeticType>(inout x: T) -> T { x += x/x; return x }

// CGFloat versions apparently need separate implementations
// prefix public func +++(inout x: CGFloat) -> CGFloat { defer { x += 1 }; return x }
// prefix public func +++(inout x: CGFloat) -> CGFloat { x += 1; return x }

// via "torquato"

postfix operator ++++ {}
postfix public func ++++<T: BidirectionalIndexType>(inout x: T) -> T { defer { x = x.successor() }; return x }
prefix operator ++++ {}
prefix public func ++++<T: BidirectionalIndexType>(inout x: T) -> T { x = x.successor(); return x }
postfix operator ---- {}
postfix public func ----<T: BidirectionalIndexType>(inout x: T) -> T { defer { x = x.predecessor() }; return x }
prefix operator ---- {}
prefix public func ----<T: BidirectionalIndexType>(inout x: T) -> T { x = x.predecessor(); return x }
