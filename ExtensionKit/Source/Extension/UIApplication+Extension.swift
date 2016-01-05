//
//  UIApplication+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/30/15.
//  Copyright © 2015 foobar. All rights reserved.
//

import UIKit

// MARK: - Actions

public extension UIApplication {
    private static let _sharedApplication = UIApplication.sharedApplication()
    
    public class func openURL(URL: NSURL) {
        if _sharedApplication.canOpenURL(URL) {
           _sharedApplication.openURL(URL)
        } else {
            debugPrint("Can not execute the given action.")
        }
    }
    
    public class func makePhone(phoneNumber: String) {
        if let URL = NSURL(string: "telprompt:\(phoneNumber)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func sendMessageTo(phoneNumber: String) {
        if let URL = NSURL(string: "sms:\(phoneNumber)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func mailTo(email: String) {
        if let URL = NSURL(string: "mailto:\(email)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func clearIconBadge() {
        let badgeNumber = _sharedApplication.applicationIconBadgeNumber
        _sharedApplication.applicationIconBadgeNumber = 1
        _sharedApplication.applicationIconBadgeNumber = 0
        _sharedApplication.cancelAllLocalNotifications()
        _sharedApplication.applicationIconBadgeNumber = badgeNumber
    }
    
    public class func sendAction(action: Selector, fromSender sender: AnyObject?) -> Bool {
        // Get the target in the responder chain
        var target = sender
        
        while let _target = target where !_target.canPerformAction(action, withSender: sender) {
            target = _target.nextResponder()
        }
        
        if let _target  = target {
            return UIApplication.sharedApplication().sendAction(action, to: _target, from: sender, forEvent: nil)
        }
        
        return false
    }
}

public func doOpenURL(URL: NSURL) {
    UIApplication.openURL(URL)
}

public func doMakePhone(phoneNumber: String) {
    UIApplication.makePhone(phoneNumber)
}

public func doSendMessageTo(phoneNumber: String) {
    UIApplication.sendMessageTo(phoneNumber)
}

public func doMailTo(email: String) {
    UIApplication.mailTo(email)
}

public func doSendAction(action: Selector, fromSender sender: AnyObject?) -> Bool {
    return UIApplication.sendAction(action, fromSender: sender)
}

// MARK: - Properties

// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
public func doMakeStatusBarDark() {
    UIApplication.sharedApplication().statusBarStyle = .Default
}

// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
public func doMakeStatusBarLight() {
    UIApplication.sharedApplication().statusBarStyle = .LightContent
}