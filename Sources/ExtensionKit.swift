//
//  ExtensionKit.swift
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

public protocol ExtensionProvider: class {
    associatedtype ProviderType
    var ext: ProviderType { get }
    static var ext: ProviderType.Type { get }
}

public extension ExtensionProvider {
    public var ext: Extension<Self> {
        return Extension(self)
    }
    
    public static var ext: Extension<Self>.Type {
        return Extension<Self>.self
    }
}

public final class Extension<Base> {
    internal let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

// MARK: - Classess Extensions

extension CGContext: ExtensionProvider {}
extension NSObject: ExtensionProvider {}

// MARK: - Array

public struct ArrayExtension<Element> {
    internal var base: Array<Element>
    public init(_ base: Array<Element>) {
        self.base = base
    }
}

public extension Array {
    public var ext: ArrayExtension<Element> {
        get { return ArrayExtension(self) }
        set { self = newValue.base }
    }
}

// MARK: - Dictionary

public struct DictionaryExtension<Key: Hashable, Value> {
    internal var base: [Key: Value]
    public init(_ base: [Key: Value]) {
        self.base = base
    }
}

public extension Dictionary {
    public var ext: DictionaryExtension<Key, Value> {
        get { return DictionaryExtension(self) }
        set { self = newValue.base }
    }
}

// MARK: - Data

public struct DataExtension {
    internal var base: Data
    public init(_ base: Data) {
        self.base = base
    }
}

public extension Data {
    public var ext: DataExtension {
        get { return DataExtension(self) }
        set { self = newValue.base }
    }
    
    public static var ext: DataExtension.Type {
        return DataExtension.self
    }
}

// MARK: - String

public struct StringExtension {
    internal var base: String
    public init(_ base: String) {
        self.base = base
    }
}

public extension String {
    public var ext: StringExtension {
        get { return StringExtension(self) }
        set { self = newValue.base }
    }
    
    public static var ext: StringExtension.Type {
        return StringExtension.self
    }
}

// MARK: - Int & Double & CGFloat & CGPoint & CGSize & CGVector & CGRect & CGAffineTransform

public struct IntExtension {
    internal var base: Int
    public init(_ base: Int) {
        self.base = base
    }
}

public extension Int {
    public var ext: IntExtension {
        get { return IntExtension(self) }
        set { self = newValue.base }
    }
}

public struct DoubleExtension {
    internal var base: Double
    public init(_ base: Double) {
        self.base = base
    }
}

public extension Double {
    public var ext: DoubleExtension {
        get { return DoubleExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGFloatExtension {
    internal var base: CGFloat
    public init(_ base: CGFloat) {
        self.base = base
    }
}

public extension CGFloat {
    public var ext: CGFloatExtension {
        get { return CGFloatExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGPointExtension {
    internal var base: CGPoint
    public init(_ base: CGPoint) {
        self.base = base
    }
}

public extension CGPoint {
    public var ext: CGPointExtension {
        get { return CGPointExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGSizeExtension {
    internal var base: CGSize
    public init(_ base: CGSize) {
        self.base = base
    }
}

public extension CGSize {
    public var ext: CGSizeExtension {
        get { return CGSizeExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGVectorExtension {
    internal var base: CGVector
    public init(_ base: CGVector) {
        self.base = base
    }
}

public extension CGVector {
    public var ext: CGVectorExtension {
        get { return CGVectorExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGRectExtension {
    internal var base: CGRect
    public init(_ base: CGRect) {
        self.base = base
    }
}

public extension CGRect {
    public var ext: CGRectExtension {
        get { return CGRectExtension(self) }
        set { self = newValue.base }
    }
}

public struct CGAffineTransformExtension {
    internal var base: CGAffineTransform
    public init(_ base: CGAffineTransform) {
        self.base = base
    }
}

public extension CGAffineTransform {
    public var ext: CGAffineTransformExtension {
        get { return CGAffineTransformExtension(self) }
        set { self = newValue.base }
    }
}











