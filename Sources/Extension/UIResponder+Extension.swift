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
        while let _responder = responder.nextResponder() {
            if _responder.isKindOfClass(cls) {
                return _responder
            }
            
            responder = _responder
        }
        
        return nil
    }
    
    public func sendAction(action: Selector) -> Bool {
        return UIApplication.sendAction(action, fromSender: self)
    }

    public func performAction(
        action: Selector,
        withFirstArgument firstArgument: AnyObject! = nil,
        withSecondArgument secondArgument: AnyObject! = nil) -> Unmanaged<AnyObject>!
    {
        var responder: UIResponder? = self
        
        while let _responder = responder where !_responder.respondsToSelector(action) {
            responder = _responder.nextResponder()
        }
        
        if nil == firstArgument {
            return responder?.performSelector(action)
        } else if nil == secondArgument {
            return responder?.performSelector(action, withObject: firstArgument)
        } else {
            return responder?.performSelector(action, withObject: firstArgument, withObject: secondArgument)
        }
    }
}