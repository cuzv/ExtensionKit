//
//  Cocoa+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/8/16.
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

import UIKit

// MARK: - Swifty Target & Action
// See: https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html

final public class ActionTrampoline<T>: NSObject {
    fileprivate let action: ((T) -> ())
    
    public init(action: @escaping ((T) -> ())) {
        self.action = action
    }
    
    @objc public func action(_ sender: AnyObject) {
        // UIControl: add(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
        if let sender = sender as? T {
            action(sender)
        }
        // UIGestureRecognizer: add(target: AnyObject, action: Selector)
        else if let sender = sender as? UIGestureRecognizer {
            action(sender.view as! T)
        }
    }
    
    #if DEBUG
    deinit {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
    #endif
}

