//
//  UIControl+Extension.swift
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

private struct AssociationKey {
    fileprivate static var touchDownHandlerWrapper: String = "com.mochxiao.uicontrol.touchDownHandlerWrapper"
    fileprivate static var touchDownRepeatHandlerWrapper: String = "com.mochxiao.uicontrol.touchDownRepeatHandlerWrapper"
    fileprivate static var touchDragInsideHandlerWrapper: String = "com.mochxiao.uicontrol.touchDragInsideHandlerWrapper"
    fileprivate static var touchDragOutsideHandlerWrapper: String = "com.mochxiao.uicontrol.touchDragOutsideHandlerWrapper"
    fileprivate static var touchDragEnterHandlerWrapper: String = "com.mochxiao.uicontrol.touchDragEnterHandlerWrapper"
    fileprivate static var touchDragExitHandlerWrapper: String = "com.mochxiao.uicontrol.touchDragExitHandlerWrapper"
    fileprivate static var touchUpInsideHandlerWrapper: String = "com.mochxiao.uicontrol.touchUpInsideHandlerWrapper"
    fileprivate static var touchUpOutsideHandlerWrapper: String = "com.mochxiao.uicontrol.touchUpOutsideHandlerWrapper"
    fileprivate static var touchCancelHandlerWrapper: String = "com.mochxiao.uicontrol.touchCancelHandlerWrapper"
    fileprivate static var valueChangedHandlerWrapper: String = "com.mochxiao.uicontrol.valueChangedHandlerWrapper"
    fileprivate static var primaryActionTriggeredHandlerWrapper: String = "com.mochxiao.uicontrol.primaryActionTriggeredHandlerWrapper"
    fileprivate static var editingDidBeginHandlerWrapper: String = "com.mochxiao.uicontrol.editingDidBeginHandlerWrapper"
    fileprivate static var editingChangedHandlerWrapper: String = "com.mochxiao.uicontrol.editingChangedHandlerWrapper"
    fileprivate static var editingDidEndHandlerWrapper: String = "com.mochxiao.uicontrol.editingDidEndHandlerWrapper"
    fileprivate static var editingDidEndOnExitHandlerWrapper: String = "com.mochxiao.uicontrol.editingDidEndOnExitHandlerWrapper"
    fileprivate static var allTouchEventsHandlerWrapper: String = "com.mochxiao.uicontrol.allTouchEventsHandlerWrapper"
    fileprivate static var allEditingEventsHandlerWrapper: String = "com.mochxiao.uicontrol.allEditingEventsHandlerWrapper"
    fileprivate static var applicationReservedHandlerWrapper: String = "com.mochxiao.uicontrol.applicationReservedHandlerWrapper"
    fileprivate static var systemReservedHandlerWrapper: String = "com.mochxiao.uicontrol.systemReservedHandlerWrapper"
    fileprivate static var allEventsHandlerWrapper: String = "com.mochxiao.uicontrol.allEventsHandlerWrapper"
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
        if events.contains(.touchDown) {
            associate(retainObject: object, forKey: &AssociationKey.touchDownHandlerWrapper)
        }
        if events.contains(.touchDownRepeat) {
            associate(retainObject: object, forKey: &AssociationKey.touchDownRepeatHandlerWrapper)
        }
        if events.contains(.touchDragInside)  {
            associate(retainObject: object, forKey: &AssociationKey.touchDragInsideHandlerWrapper)
        }
        if events.contains(.touchDragOutside) {
            associate(retainObject: object, forKey: &AssociationKey.touchDragOutsideHandlerWrapper)
        }
        if events.contains(.touchDragEnter) {
            associate(retainObject: object, forKey: &AssociationKey.touchDragEnterHandlerWrapper)
        }
        if events.contains(.touchDragExit) {
            associate(retainObject: object, forKey: &AssociationKey.touchDragExitHandlerWrapper)
        }
        if events.contains(.touchUpInside) {
            associate(retainObject: object, forKey: &AssociationKey.touchUpInsideHandlerWrapper)
        }
        if events.contains(.touchUpOutside) {
            associate(retainObject: object, forKey: &AssociationKey.touchUpOutsideHandlerWrapper)
        }
        if events.contains(.touchCancel) {
            associate(retainObject: object, forKey: &AssociationKey.touchCancelHandlerWrapper)
        }
        if events.contains(.valueChanged) {
            associate(retainObject: object, forKey: &AssociationKey.valueChangedHandlerWrapper)
        }
        if events.contains(.editingDidBegin) {
            associate(retainObject: object, forKey: &AssociationKey.editingDidBeginHandlerWrapper)
        }
        if events.contains(.editingChanged) {
            associate(retainObject: object, forKey: &AssociationKey.editingChangedHandlerWrapper)
        }
        if events.contains(.editingDidEnd) {
            associate(retainObject: object, forKey: &AssociationKey.editingDidEndHandlerWrapper)
        }
        if events.contains(.allTouchEvents) {
            associate(retainObject: object, forKey: &AssociationKey.allTouchEventsHandlerWrapper)
        }
        if events.contains(.editingDidEndOnExit) {
            associate(retainObject: object, forKey: &AssociationKey.editingDidEndOnExitHandlerWrapper)
        }
        if events.contains(.allEditingEvents) {
            associate(retainObject: object, forKey: &AssociationKey.allEditingEventsHandlerWrapper)
        }
        if events.contains(.applicationReserved) {
            associate(retainObject: object, forKey: &AssociationKey.applicationReservedHandlerWrapper)
        }
        if events.contains(.systemReserved) {
            associate(retainObject: object, forKey: &AssociationKey.systemReservedHandlerWrapper)
        }
        if events.contains(.allEvents) {
            associate(retainObject: object, forKey: &AssociationKey.allEventsHandlerWrapper)
        }
        
        if #available(iOS 9.0, *) {
            if events.contains(.primaryActionTriggered) {
                associate(retainObject: object, forKey: &AssociationKey.primaryActionTriggeredHandlerWrapper)
            }
        }
    }
}
