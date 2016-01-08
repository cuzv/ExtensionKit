//
//  UIScrollView+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/4/16.
//  Copyright © 2016 Moch Xiao (https://github.com/cuzv).
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

@IBDesignable
public extension UIScrollView {
    @IBInspectable public var insetTop: CGFloat {
        get { return contentInset.top }
        set {
            var inset = contentInset
            inset.top = newValue
            contentInset = inset
        }
    }
    
    @IBInspectable public var insetLeft: CGFloat {
        get { return contentInset.left }
        set {
            var inset = contentInset
            inset.left = newValue
            contentInset = inset
        }
    }
    
    @IBInspectable public var insetBottom: CGFloat {
        get { return contentInset.bottom }
        set {
            var inset = contentInset
            inset.bottom = newValue
            contentInset = inset
        }
    }
    
    @IBInspectable public var insetRight: CGFloat {
        get { return contentInset.right }
        set {
            var inset = contentInset
            inset.right = newValue
            contentInset = inset
        }
    }
    
    @IBInspectable public var contentOffsetX: CGFloat {
        get { return contentOffset.x }
        set {
            var offset = contentOffset
            offset.x = newValue
            contentOffset = offset
        }
    }
    
    @IBInspectable public var contentOffsetY: CGFloat {
        get { return contentOffset.y }
        set {
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
    }
    
    @IBInspectable public var contentSizeWidth: CGFloat {
        get { return contentSize.width }
        set {
            var size = contentSize
            size.width = newValue
            contentSize = size
        }
    }
    
    @IBInspectable public var contentSizeHeight: CGFloat {
        get { return contentSize.height }
        set {
            var size = contentSize
            size.height = newValue
            contentSize = size
        }
    }
}
