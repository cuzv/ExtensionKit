//
//  UITextField+Extension.swift
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
    fileprivate static var textFieldTextObserver: String = "com.mochxiao.uitextfield.textFieldTextObserver"
    fileprivate static var contentInsets: String = "com.mochxiao.uitextfield.contentInsets"
}

// MARK: -

public extension UITextField {
    public var contentInsets: UIEdgeInsets {
        get {
            if let value = associatedObject(forKey: &AssociationKey.contentInsets) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            return UIEdgeInsets.zero
        }
        set { associate(retainObject: NSValue(uiEdgeInsets: newValue), forKey: &AssociationKey.contentInsets) }
    }
    
    var _ek_intrinsicContentSize: CGSize {
        // MARK: 4 fucking Xcode8/iOS10 SDKs
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: bounds.size.height))
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    func _ek_textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    
    func _ek_editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
}

// MARK: - TextObserver Extension

private extension UITextField {
    var textFieldTextObserver: TextObserver {
        get { return associatedObject(forKey: &AssociationKey.textFieldTextObserver) as! TextObserver }
        set { associate(retainObject: newValue, forKey: &AssociationKey.textFieldTextObserver) }
    }
}

public extension UITextField {
    public func setupTextObserver(maxLength: Int = 100, actionHandler: ((Int) -> ())? = nil) {
        let textObserver = TextObserver(maxLength: maxLength) { (remainCount) -> () in
            actionHandler?(remainCount)
        }
        textObserver.observe(textField: self)
        textFieldTextObserver = textObserver
    }
}
