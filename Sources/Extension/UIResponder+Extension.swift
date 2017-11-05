//
//  UIResponder+Extension.swift
//  Copyright (c) 2015-2016 Red Rain (http://mochxiao.com).
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

public extension UIResponder {
    public func responder(ofClass cls: AnyClass) -> UIResponder? {
        var responder = self
        while let _responder = responder.next {
            if _responder.isKind(of: cls) {
                return _responder
            }
            
            responder = _responder
        }
        return nil
    }
    
    @discardableResult
    public func sendAction(_ action: Selector) -> Bool {
        return UIApplication.sendAction(action, fromSender: self)
    }

    @discardableResult
    public func performAction(
        _ action: Selector,
        _ firstArgument: AnyObject! = nil,
        _ secondArgument: AnyObject! = nil) -> Unmanaged<AnyObject>!
    {
        var responder: UIResponder? = self
        while let _responder = responder , !_responder.responds(to: action) {
            responder = _responder.next
        }
        
        if nil == firstArgument {
            return responder?.perform(action)
        } else if nil == secondArgument {
            return responder?.perform(action, with: firstArgument)
        } else {
            return responder?.perform(action, with: firstArgument, with: secondArgument)
        }
    }
}
