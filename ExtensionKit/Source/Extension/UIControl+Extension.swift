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

private struct AssociationKey {
    private static var touchDownHandlerWrapper: String = "touchDownHandlerWrapper"
    private static var touchDownRepeatHandlerWrapper: String = "touchDownRepeatHandlerWrapper"
    private static var touchDragInsideHandlerWrapper: String = "touchDragInsideHandlerWrapper"
    private static var touchDragOutsideHandlerWrapper: String = "touchDragOutsideHandlerWrapper"
    private static var touchDragEnterHandlerWrapper: String = "touchDragEnterHandlerWrapper"
    private static var touchDragExitHandlerWrapper: String = "touchDragExitHandlerWrapper"
    private static var touchUpInsideHandlerWrapper: String = "touchUpInsideHandlerWrapper"
    private static var touchUpOutsideHandlerWrapper: String = "touchUpOutsideHandlerWrapper"
    private static var touchCancelHandlerWrapper: String = "touchCancelHandlerWrapper"
    private static var valueChangedHandlerWrapper: String = "valueChangedHandlerWrapper"
    private static var primaryActionTriggeredHandlerWrapper: String = "primaryActionTriggeredHandlerWrapper"
    private static var editingDidBeginHandlerWrapper: String = "editingDidBeginHandlerWrapper"
    private static var editingChangedHandlerWrapper: String = "editingChangedHandlerWrapper"
    private static var editingDidEndHandlerWrapper: String = "editingDidEndHandlerWrapper"
    private static var editingDidEndOnExitHandlerWrapper: String = "editingDidEndOnExitHandlerWrapper"
    private static var allTouchEventsHandlerWrapper: String = "allTouchEventsHandlerWrapper"
    private static var allEditingEventsHandlerWrapper: String = "allEditingEventsHandlerWrapper"
    private static var applicationReservedHandlerWrapper: String = "applicationReservedHandlerWrapper"
    private static var systemReservedHandlerWrapper: String = "systemReservedHandlerWrapper"
    private static var allEventsHandlerWrapper: String = "allEventsHandlerWrapper"
}

// MARK: - UIControl Action

public protocol UIControlActionFunctionProtocol {}
extension UIControl: UIControlActionFunctionProtocol {}

public extension UIControlActionFunctionProtocol where Self: UIControl {
    public func addControlEvents(events: UIControlEvents, handler: Self -> ()) {
        let trampoline = ActionTrampoline(action: handler)
        addTarget(trampoline, action: NSSelectorFromString("action:"), forControlEvents: events)
        associateObject(trampoline, forEvents: events)
    }
    
    private func associateObject(object: AnyObject, forEvents events: UIControlEvents) {
        if events == .TouchDown {
            associateRetainObject(object, forKey: &AssociationKey.touchDownHandlerWrapper)
        } else if events == .TouchDownRepeat {
            associateRetainObject(object, forKey: &AssociationKey.touchDownRepeatHandlerWrapper)
        } else if events == .TouchDragInside {
            associateRetainObject(object, forKey: &AssociationKey.touchDragInsideHandlerWrapper)
        } else if events == .TouchDragOutside {
            associateRetainObject(object, forKey: &AssociationKey.touchDragOutsideHandlerWrapper)
        } else if events == .TouchDragEnter {
            associateRetainObject(object, forKey: &AssociationKey.touchDragEnterHandlerWrapper)
        } else if events == .TouchDragExit {
            associateRetainObject(object, forKey: &AssociationKey.touchDragExitHandlerWrapper)
        } else if events == .TouchUpInside {
            associateRetainObject(object, forKey: &AssociationKey.touchUpInsideHandlerWrapper)
        } else if events == .TouchUpOutside {
            associateRetainObject(object, forKey: &AssociationKey.touchUpOutsideHandlerWrapper)
        } else if events == .TouchCancel {
            associateRetainObject(object, forKey: &AssociationKey.touchCancelHandlerWrapper)
        } else if events == .ValueChanged {
            associateRetainObject(object, forKey: &AssociationKey.valueChangedHandlerWrapper)
        } else if events == .EditingDidBegin {
            associateRetainObject(object, forKey: &AssociationKey.editingDidBeginHandlerWrapper)
        } else if events == .EditingChanged {
            associateRetainObject(object, forKey: &AssociationKey.editingChangedHandlerWrapper)
        } else if events == .EditingDidEnd {
            associateRetainObject(object, forKey: &AssociationKey.editingDidEndHandlerWrapper)
        } else if events == .AllTouchEvents {
            associateRetainObject(object, forKey: &AssociationKey.allTouchEventsHandlerWrapper)
        } else if events == .EditingDidEndOnExit {
            associateRetainObject(object, forKey: &AssociationKey.editingDidEndOnExitHandlerWrapper)
        } else if events == .AllEditingEvents {
            associateRetainObject(object, forKey: &AssociationKey.allEditingEventsHandlerWrapper)
        } else if events == .ApplicationReserved {
            associateRetainObject(object, forKey: &AssociationKey.applicationReservedHandlerWrapper)
        } else if events == .SystemReserved {
            associateRetainObject(object, forKey: &AssociationKey.systemReservedHandlerWrapper)
        } else if events == .AllEvents {
            associateRetainObject(object, forKey: &AssociationKey.allEventsHandlerWrapper)
        }
        
        if #available(iOS 9.0, *) {
            if events == .PrimaryActionTriggered {
                associateRetainObject(object, forKey: &AssociationKey.primaryActionTriggeredHandlerWrapper)
            }
        }
    }
}