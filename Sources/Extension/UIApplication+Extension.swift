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
    
    public class func open(URL: Foundation.URL) {
        if _sharedApplication.canOpenURL(URL) {
           _sharedApplication.openURL(URL)
        } else {
            logging("Can not execute the given action.")
        }
    }
    
    public class func open(urlPath: String) {
        if let URL = URL(string: urlPath) {
            UIApplication.open(URL: URL)
        }
    }
    
    public class func makePhone(to phoneNumber: String) {
        open(urlPath: "telprompt:\(phoneNumber)")
    }
    
    public class func sendMessage(to phoneNumber: String) {
        open(urlPath: "sms:\(phoneNumber)")
    }
    
    public class func email(to email: String) {
        open(urlPath: "mailto:\(email)")
    }
    
    public class func chatQQ(to qq: String) {
        open(urlPath: "mqq://im/chat?chat_type=wpa&uin=\(qq)&version=1&src_type=iOS")
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
    
    /// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
    public class func makeStatusBarDark() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    /// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
    public class func makeStatusBarLight() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
