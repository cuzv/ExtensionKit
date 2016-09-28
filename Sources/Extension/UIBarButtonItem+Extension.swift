//
//  UIBarButtonItem+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 8/12/16.
//  Copyright © 2016 Moch. All rights reserved.
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
    internal class func performActionHandler(sender: UIBarButtonItem) {
        sender.barButtonItemActionHandlerWrapper?.invoke(sender)
    }
}
