//
//  DashLineView.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 4/5/16.
//  Copyright © @2016 Moch Xiao (http://mochxiao.com).
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

final public class DashLineView: UIView {
    public var spacing: CGFloat = 2
    public var lineColor: UIColor = UIColor.separatorDefaultColor
    public var horizontal: Bool = true
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        backgroundColor?.setFill()
        UIRectFill(rect)
        
        let lineWidth = horizontal ? CGRectGetHeight(rect).ceilly : CGRectGetWidth(rect).ceilly
        let startPoint = horizontal ? CGPointMake((lineWidth / 2).ceilly, (CGRectGetHeight(rect) / 2).ceilly) :
                                      CGPointMake((CGRectGetWidth(rect) / 2).ceilly , (lineWidth / 2).ceilly)
        let endPoint = horizontal ? CGPointMake(CGRectGetWidth(rect) - (lineWidth / 2).ceilly, (CGRectGetHeight(rect) / 2).ceilly) :
                                    CGPointMake((CGRectGetWidth(rect) / 2).ceilly , CGRectGetHeight(rect) - (lineWidth / 2).ceilly)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        let lengths = [spacing, spacing]
        CGContextSetLineDash(context, 0, lengths, lengths.count)
        CGContextMoveToPoint(context, startPoint.x, startPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        CGContextStrokePath(context)
    }
}
