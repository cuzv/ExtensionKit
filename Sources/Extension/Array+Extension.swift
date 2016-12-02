//
//  Array+Extension.swift
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

// MARK: - Array

public extension ArrayExtension {
    public mutating func exchange(lhs index: Int, rhs otherIndex: Int) {
        if base.count <= index || base.count <= otherIndex  {
            fatalError("Index beyond boundary.")
        }
        if index >= otherIndex {
            fatalError("lhs must less than rhs.")
        }

        let firstItemData = base[index]
        let firstRange = Range(index ..< index + 1)
        
        let secondaryItemData = base[otherIndex]
        let secondaryRange = Range(otherIndex ..< otherIndex + 1)
        
        base.replaceSubrange(firstRange, with: [secondaryItemData])
        base.replaceSubrange(secondaryRange, with: [firstItemData])
    }
    
    public mutating func replace(at index: Int, with element: Element) {
        if base.count <= index {
            fatalError("Index beyond boundary.")
        }
        let range = Range(index ..< index + 1)
        base.replaceSubrange(range, with: [element])
    }
    
    public mutating func replaceLast(_ element: Element) {
        replace(at: base.count - 1, with: element)
    }
    
    public mutating func replaceFirst(_ element: Element) {
        replace(at: 0, with: element)
    }
    
    public var prettyDebugDescription: String {
        var output: [String] = []
        var index = 0
        for item in base {
            output.append("\(index): \(item)")
            index += 1
        }
        return output.joined(separator: "\n")
    }
    
    public var second: Element? {
        if base.count > 1 { return base[1] }
        return nil
    }
    
    public var third: Element? {
        if base.count > 2 { return base[2] }
        return nil
    }
    
    public var fourth: Element? {
        if base.count > 3 { return base[3] }
        return nil
    }
    
    public var fifthly: Element? {
        if base.count > 4 { return base[4] }
        return nil
    }
    
    public var sixth: Element? {
        if base.count > 5 { return base[5] }
        return nil
    }
    
    public var seventh: Element? {
        if base.count > 6 { return base[6] }
        return nil
    }
    
    public var eighth: Element? {
        if base.count > 7 { return base[7] }
        return nil
    }
    
    public var ninth: Element? {
        if base.count > 8 { return base[8] }
        return nil
    }
    
    public var tenth: Element? {
        if base.count > 9 { return base[9] }
        return nil
    }
}
