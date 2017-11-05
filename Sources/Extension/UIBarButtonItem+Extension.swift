//
//  UIBarButtonItem+Extension.swift
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

// MARK: - AssociationKey

private struct AssociationKey {
    fileprivate static var barButtonItemActionHandlerWrapper: String = "com.mochxiao.uibarbuttonitem.barButtonItemActionHandlerWrapper"
}

// MARK: - 

public extension UIBarButtonItem {
    public class func make(fixedSpace width: CGFloat) -> UIBarButtonItem {
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = width
        return spacing
    }
}

// MARK: - 

public extension UIBarButtonItem {
    fileprivate var barButtonItemActionHandlerWrapper: ClosureDecorator<UIBarButtonItem>? {
        get { return associatedObject(forKey: &AssociationKey.barButtonItemActionHandlerWrapper) as? ClosureDecorator<UIBarButtonItem> }
        set { associate(retainObject: newValue, forKey: &AssociationKey.barButtonItemActionHandlerWrapper) }
    }
    
    public class func make(title: String, actionHandler: ((UIBarButtonItem) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(UIBarButtonItem.performActionHandler(sender:)))
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }
        return barButtonItem
    }
    
    public class func make(image: UIImage?, actionHandler: ((UIBarButtonItem) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: image?.original, style: .plain, target: self, action: #selector(UIBarButtonItem.performActionHandler(sender:)))
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }
        return barButtonItem
    }
    
    public class func make(systemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(UIBarButtonItem.performActionHandler(sender:)))
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }
        return barButtonItem
    }
    
    /// Helper func
    @objc internal class func performActionHandler(sender: UIBarButtonItem) {
        sender.barButtonItemActionHandlerWrapper?.invoke(sender)
    }
}
