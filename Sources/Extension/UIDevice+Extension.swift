//
//  UIDevice+Extension.swift
//  Copyright (c) 2015-2016 Moch Xiao (http://mochxiao.com).
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
    fileprivate static let _currentDevice = UIDevice.current
    
    public class var sysVersion: String {
        return _currentDevice.systemVersion
    }
    
    public class var majorVersion: Int {
        return Int(UIDevice.sysVersion.components(separatedBy: ".").first!)!
    }
    
    public class var iOS7x: Bool {
        return majorVersion >= 7
    }
    
    public class var iOS8x: Bool {
        return majorVersion >= 8
    }
    
    public class var iOS9x: Bool {
        return majorVersion >= 9
    }
    
    public class var iOS10x: Bool {
        return majorVersion >= 10
    }
    
    public class var iOS11x: Bool {
        return majorVersion >= 11
    }

    fileprivate static func deviceOrientation(_ result: (UIDeviceOrientation) -> ()) {
        if !_currentDevice.isGeneratingDeviceOrientationNotifications {
            _currentDevice.beginGeneratingDeviceOrientationNotifications()
        }
        result(_currentDevice.orientation)
        _currentDevice.endGeneratingDeviceOrientationNotifications()
    }
}
