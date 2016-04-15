//
//  UIResponder+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
//  Copyright © 2015 foobar. All rights reserved.
//

import UIKit

public extension UIResponder {
    public func responderOfClass(cls: AnyClass) -> UIResponder? {
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
        return doSend(action: action, fromSender: self)
    }
}