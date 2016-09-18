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
    fileprivate static let _sharedApplication = UIApplication.shared
    
    public class func openURL(_ URL: Foundation.URL) {
        if _sharedApplication.canOpenURL(URL) {
           _sharedApplication.openURL(URL)
        } else {
            debugPrint("Can not execute the given action.")
        }
    }
    
    public class func openURLPath(_ urlPath: String) {
        if let URL = URL(string: urlPath) {
            UIApplication.openURL(URL)
        }
    }
    
    public class func makePhone(_ phoneNumber: String) {
        if let URL = URL(string: "telprompt:\(phoneNumber)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func sendMessageTo(_ phoneNumber: String) {
        if let URL = URL(string: "sms:\(phoneNumber)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func emailTo(_ email: String) {
        if let URL = URL(string: "mailto:\(email)") {
            UIApplication.openURL(URL)
        }
    }
    
    public class func chatToQQ(_ qq: String) {
        if let URL = URL(string: "mqq://im/chat?chat_type=wpa&uin=\(qq)&version=1&src_type=iOS") {
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
    
    public class func sendAction(_ action: Selector, fromSender sender: AnyObject?, forEvent event: UIEvent? = nil) -> Bool {
        // Get the target in the responder chain
        var target = sender
        
        while let _target = target , !_target.canPerformAction(action, withSender: sender) {
            target = _target.next
        }
        
        if let _target  = target {
            return UIApplication.shared.sendAction(action, to: _target, from: sender, for: event)
        }
        
        return false
    }
}

public func doOpenURL(_ URL: Foundation.URL) {
    UIApplication.openURL(URL)
}

public func doMakePhone(_ phoneNumber: String) {
    UIApplication.makePhone(phoneNumber)
}

public func doSendMessageTo(_ phoneNumber: String) {
    UIApplication.sendMessageTo(phoneNumber)
}

public func doMailTo(_ email: String) {
    UIApplication.emailTo(email)
}

public func doChatToQQ(_ qq: String) {
    UIApplication.chatToQQ(qq)
}

public func doSendAction(_ action: Selector, fromSender sender: AnyObject?, forEvent event: UIEvent? = nil) -> Bool {
    return UIApplication.sendAction(action, fromSender: sender, forEvent: event)
}

// MARK: - Properties

/// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
public func doMakeStatusBarDark() {
    UIApplication.shared.statusBarStyle = .default
}

/// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
public func doMakeStatusBarLight() {
    UIApplication.shared.statusBarStyle = .lightContent
}
