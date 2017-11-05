//
//  UINavigationBar+Extension.swift
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

// MARK: - Visible & Invisible

public extension UINavigationBar {
    /// Only effect when `translucent` is true.
    public func setBackgroundVisible(_ visible: Bool) {
        if !isTranslucent {
            logging("`translucent` must be true if you wanna change background visible.")
        }
        
        setBackgroundImage(visible ? nil : UIImage(), for: .default)
        shadowImage = visible ? nil : UIImage()
    }
}

// MARK: - Hairline

public extension UINavigationBar {
    public var shimShadowView: UIView? {
        if let
            _backgroundView = value(forKey: "_backgroundView") as? NSObject,
            let _shadowView = _backgroundView.value(forKey: "_shadowView") as? UIView
        {
            return _shadowView
        }
        return nil
    }
}
