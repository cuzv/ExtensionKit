//
//  TouchesButton.swift
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

// MARK: - TouchesEdgeInsets

public class TouchesButton: UIButton {
    public var touchesEdgeInsets: UIEdgeInsets?
    private var touchesLocation: CGRect {
        if let touchesEdgeInsets = self.touchesEdgeInsets {
            let top = touchesEdgeInsets.top
            let left = touchesEdgeInsets.left
            let bottom = touchesEdgeInsets.bottom
            let right = touchesEdgeInsets.right
            if 0.0 != top || 0.0 != left || 0.0 != bottom || 0.0 != right {
                return CGRectMake(
                    self.bounds.origin.x - left,
                    self.bounds.origin.y - top,
                    self.bounds.size.width + left + right,
                    self.bounds.size.height + top + bottom
                )
            }
        }
        
        return self.bounds
    }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectEqualToRect(touchesLocation, self.bounds) {
            return super.pointInside(point, withEvent: event)
        }
        
        return CGRectContainsPoint(touchesLocation, point) ? true : false
    }
}
