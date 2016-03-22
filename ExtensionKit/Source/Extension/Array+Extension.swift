//
//  Array+Extension.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/7/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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

public extension Array {
    public mutating func exchangeElementAtIndex(index: Int, withElementAtIndex otherIndex: Int) {
        if count <= index || count <= otherIndex  {
            fatalError("Index beyond boundary.")
        }
        
        let firstItemData = self[index]
        let firstRange = Range(index ..< index + 1)
        
        let secondaryItemData = self[otherIndex]
        let secondaryRange = Range(otherIndex ..< otherIndex + 1)
        
        replaceRange(firstRange, with: [secondaryItemData])
        replaceRange(secondaryRange, with: [firstItemData])
    }
    
    public mutating func replaceElementAtIndex(index: Int, withElement element: Element) {
        if count <= index {
            fatalError("Index beyond boundary.")
        }
        let range = Range(index ..< index + 1)
        replaceRange(range, with: [element])
    }
    
    public mutating func replaceLast(element: Element) {
        replaceElementAtIndex(count-1, withElement: element)
    }
    
    public mutating func replaceFirst(element: Element) {
        replaceElementAtIndex(0, withElement: element)
    }
    
    public var prettyDebugDescription: String {
        var output: [String] = []
        var index = 0
        for item in self {
            output.append("\(index): \(item)")
            index += 1
        }
        return output.joinWithSeparator("\n")
    }
}
