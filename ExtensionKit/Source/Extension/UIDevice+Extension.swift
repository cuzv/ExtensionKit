//
//  UIDevice+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
//  Copyright © @2015 Moch Xiao (https://github.com/cuzv).
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

public extension UIDevice {
    private static let _currentDevice = UIDevice.currentDevice()
    
    public class var sysVersion: String {
        return _currentDevice.systemVersion
    }
    
    public class var majorVersion: Int {
        return Int(UIDevice.sysVersion.componentsSeparatedByString(".").first!)!
    }

    private static let _iOS7Plus = Float(UIDevice.sysVersion) >= 7.0
    public class var iOS7Plus: Bool {
        return _iOS7Plus
    }

    private static let _iOS8Plus = Float(UIDevice.sysVersion) >= 8.0
    public class var iOS8Plus: Bool {
        return _iOS8Plus
    }
    
    private static func deviceOrientation(result: (UIDeviceOrientation) -> ()) {
        if !_currentDevice.generatesDeviceOrientationNotifications {
            _currentDevice.beginGeneratingDeviceOrientationNotifications()
        }
        result(_currentDevice.orientation)
        _currentDevice.endGeneratingDeviceOrientationNotifications()
    }
}