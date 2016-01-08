//
//  UIControl+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/4/16.
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

// MARK: - Events action handler

private struct AssociationKey {
    private static var WrapClosure: String = "closureWrapper"
}

private extension UIControl {
    private var closureWrapper: ClosureWrapper<UIControl, Any> {
        get { return associatedObjectForKey(&AssociationKey.WrapClosure) as! ClosureWrapper<UIControl, Any> }
        set { associateRetainObject(newValue, forKey: &AssociationKey.WrapClosure) }
    }
}

public extension UIControl {
    public func addControlEvents(events: UIControlEvents, actionHandler: ((T: UIControl, Any?) -> ())) {
        addTarget(self, action: "handleEventsAction:", forControlEvents: events)
        closureWrapper = ClosureWrapper(closure: actionHandler, holder: self)
    }
    
    internal func handleEventsAction(sender: UIControl) {
        closureWrapper.invoke()
    }
}