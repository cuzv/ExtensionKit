//
//  UITextView+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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
    private static var textViewTextObserver: String = "textViewTextObserver"
}

// MARK: - TextObserver Extension

private extension UITextView {
    private var textViewTextObserver: TextObserver {
        get { return associatedObjectForKey(&AssociationKey.textViewTextObserver) as! TextObserver }
        set { associateRetainObject(newValue, forKey: &AssociationKey.textViewTextObserver) }
    }
}

public extension UITextView {
    public func setupTextObserver(maxLength maxLength: Int = 100, actionHandler: ((Int) -> ())? = nil) {
        let textObserver = TextObserver(maxLength: maxLength) { (remainCount) -> () in
            actionHandler?(remainCount)
        }
        textObserver.observe(self)
        self.textViewTextObserver = textObserver
    }
}

// MARK: -

public extension UITextView {
    public func scrollCursorToVisible() {
        let cursorLocation = self.selectedRange.location
        let range = NSMakeRange(0, cursorLocation)
        self.scrollRangeToVisible(range)
    }
}


