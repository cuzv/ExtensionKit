//
//  UIScrollView+Extension.swift
//  MicroShop
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
        get { return self.contentInset.top }
        set {
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    
    @IBInspectable public var insetLeft: CGFloat {
        get { return self.contentInset.left }
        set {
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    
    @IBInspectable public var insetBottom: CGFloat {
        get { return self.contentInset.bottom }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    
    @IBInspectable public var insetRight: CGFloat {
        get { return self.contentInset.right }
        set {
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
    }
    
    @IBInspectable public var contentOffsetX: CGFloat {
        get { return self.contentOffset.x }
        set {
            var contentOffset = self.contentOffset
            contentOffset.x = newValue
            self.contentOffset = contentOffset
        }
    }
    
    @IBInspectable public var contentOffsetY: CGFloat {
        get { return self.contentOffset.y }
        set {
            var contentOffset = self.contentOffset
            contentOffset.y = newValue
            self.contentOffset = contentOffset
        }
    }
    
    @IBInspectable public var contentSizeWidth: CGFloat {
        get { return self.contentSize.width }
        set {
            var contentSize = self.contentSize
            contentSize.width = newValue
            self.contentSize = contentSize
        }
    }
    
    @IBInspectable public var contentSizeHeight: CGFloat {
        get { return self.contentSize.height }
        set {
            var contentSize = self.contentSize
            contentSize.height = newValue
            self.contentSize = contentSize
        }
    }
}
