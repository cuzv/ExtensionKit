//
//  UINavigationBar+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/28/15.
//  Copyright © 2015 Moch Xiao (https://github.com/cuzv).
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

// MARK: - Visible & Invisible

public extension UINavigationBar {
    /// Set UINavigationBar can not see, but exist.
    public func setAsInvisible(tintColor tintColor: UIColor! = UIApplication.sharedApplication().keyWindow?.tintColor) {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        shadowImage = UIImage()
        barStyle = .Default
        translucent = true
        self.tintColor = tintColor
    }
    
    /// Revert `setAsInvisible` effect.
    public func setAsVisible(translucent translucent: Bool = true, tintColor: UIColor! = UINavigationBar.appearance().tintColor) {
        setBackgroundImage(nil, forBarMetrics: .Default)
        shadowImage = nil
        barStyle = translucent ? .Default : .Black
        self.translucent = translucent
        self.tintColor = tintColor
    }
}

// MARK: - Hairline

public extension UINavigationBar {
    /// The hairline view.
    public var hairline: UIView? {
        guard let cls = NSClassFromString("_UINavigationBarBackground") else { return nil }
        
        for subview in self.subviews {
            if subview.isKindOfClass(cls) {
                for view in subview.subviews {
                    if view is UIImageView && view.frame.size.height == 1.0 / UIScreen.scale {
                        return view
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Remoe the hairline view.
    public func removeHairline() {
        guard let hairline = self.hairline else { return }
        hairline.removeFromSuperview()
    }
}