//
//  UIResponder+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
//  Copyright © 2015 foobar. All rights reserved.
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
    
    public func sendAction(_ action: Selector) -> Bool {
        return UIApplication.sendAction(action, fromSender: self)
    }

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
