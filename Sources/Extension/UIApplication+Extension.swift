//
//  UIApplication+Extension.swift
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

// MARK: - Actions

public extension UIApplication {
    fileprivate static let _sharedApplication = UIApplication.shared
    
    public class func open(url: Foundation.URL) {
        if _sharedApplication.canOpenURL(url) {
           _sharedApplication.openURL(url)
        } else {
            logging("Can not execute the given action.")
        }
    }
    
    public class func open(urlPath: String) {
        if let url = URL(string: urlPath) {
            UIApplication.open(url: url)
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
