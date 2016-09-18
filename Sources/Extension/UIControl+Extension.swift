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
    fileprivate static var touchDownHandlerWrapper: String = "touchDownHandlerWrapper"
    fileprivate static var touchDownRepeatHandlerWrapper: String = "touchDownRepeatHandlerWrapper"
    fileprivate static var touchDragInsideHandlerWrapper: String = "touchDragInsideHandlerWrapper"
    fileprivate static var touchDragOutsideHandlerWrapper: String = "touchDragOutsideHandlerWrapper"
    fileprivate static var touchDragEnterHandlerWrapper: String = "touchDragEnterHandlerWrapper"
    fileprivate static var touchDragExitHandlerWrapper: String = "touchDragExitHandlerWrapper"
    fileprivate static var touchUpInsideHandlerWrapper: String = "touchUpInsideHandlerWrapper"
    fileprivate static var touchUpOutsideHandlerWrapper: String = "touchUpOutsideHandlerWrapper"
    fileprivate static var touchCancelHandlerWrapper: String = "touchCancelHandlerWrapper"
    fileprivate static var valueChangedHandlerWrapper: String = "valueChangedHandlerWrapper"
    fileprivate static var primaryActionTriggeredHandlerWrapper: String = "primaryActionTriggeredHandlerWrapper"
    fileprivate static var editingDidBeginHandlerWrapper: String = "editingDidBeginHandlerWrapper"
    fileprivate static var editingChangedHandlerWrapper: String = "editingChangedHandlerWrapper"
    fileprivate static var editingDidEndHandlerWrapper: String = "editingDidEndHandlerWrapper"
    fileprivate static var editingDidEndOnExitHandlerWrapper: String = "editingDidEndOnExitHandlerWrapper"
    fileprivate static var allTouchEventsHandlerWrapper: String = "allTouchEventsHandlerWrapper"
    fileprivate static var allEditingEventsHandlerWrapper: String = "allEditingEventsHandlerWrapper"
    fileprivate static var applicationReservedHandlerWrapper: String = "applicationReservedHandlerWrapper"
    fileprivate static var systemReservedHandlerWrapper: String = "systemReservedHandlerWrapper"
    fileprivate static var allEventsHandlerWrapper: String = "allEventsHandlerWrapper"
}

// MARK: - UIControl Action

public protocol UIControlActionFunctionProtocol {}
extension UIControl: UIControlActionFunctionProtocol {}

public extension UIControlActionFunctionProtocol where Self: UIControl {
    public func addControlEvents(_ events: UIControlEvents, handler: @escaping (Self) -> ()) {
        let trampoline = ActionTrampoline(action: handler)
        addTarget(trampoline, action: NSSelectorFromString("action:"), for: events)
        associate(object: trampoline, forEvents: events)
    }
    
    fileprivate func associate(object: AnyObject, forEvents events: UIControlEvents) {
        if events == .touchDown {
            associate(retainObject: object, forKey: &AssociationKey.touchDownHandlerWrapper)
        } else if events == .touchDownRepeat {
            associate(retainObject: object, forKey: &AssociationKey.touchDownRepeatHandlerWrapper)
        } else if events == .touchDragInside {
            associate(retainObject: object, forKey: &AssociationKey.touchDragInsideHandlerWrapper)
        } else if events == .touchDragOutside {
            associate(retainObject: object, forKey: &AssociationKey.touchDragOutsideHandlerWrapper)
        } else if events == .touchDragEnter {
            associate(retainObject: object, forKey: &AssociationKey.touchDragEnterHandlerWrapper)
        } else if events == .touchDragExit {
            associate(retainObject: object, forKey: &AssociationKey.touchDragExitHandlerWrapper)
        } else if events == .touchUpInside {
            associate(retainObject: object, forKey: &AssociationKey.touchUpInsideHandlerWrapper)
        } else if events == .touchUpOutside {
            associate(retainObject: object, forKey: &AssociationKey.touchUpOutsideHandlerWrapper)
        } else if events == .touchCancel {
            associate(retainObject: object, forKey: &AssociationKey.touchCancelHandlerWrapper)
        } else if events == .valueChanged {
            associate(retainObject: object, forKey: &AssociationKey.valueChangedHandlerWrapper)
        } else if events == .editingDidBegin {
            associate(retainObject: object, forKey: &AssociationKey.editingDidBeginHandlerWrapper)
        } else if events == .editingChanged {
            associate(retainObject: object, forKey: &AssociationKey.editingChangedHandlerWrapper)
        } else if events == .editingDidEnd {
            associate(retainObject: object, forKey: &AssociationKey.editingDidEndHandlerWrapper)
        } else if events == .allTouchEvents {
            associate(retainObject: object, forKey: &AssociationKey.allTouchEventsHandlerWrapper)
        } else if events == .editingDidEndOnExit {
            associate(retainObject: object, forKey: &AssociationKey.editingDidEndOnExitHandlerWrapper)
        } else if events == .allEditingEvents {
            associate(retainObject: object, forKey: &AssociationKey.allEditingEventsHandlerWrapper)
        } else if events == .applicationReserved {
            associate(retainObject: object, forKey: &AssociationKey.applicationReservedHandlerWrapper)
        } else if events == .systemReserved {
            associate(retainObject: object, forKey: &AssociationKey.systemReservedHandlerWrapper)
        } else if events == .allEvents {
            associate(retainObject: object, forKey: &AssociationKey.allEventsHandlerWrapper)
        }
        
        if #available(iOS 9.0, *) {
            if events == .primaryActionTriggered {
                associate(retainObject: object, forKey: &AssociationKey.primaryActionTriggeredHandlerWrapper)
            }
        }
    }
}
