//
//  DashlineView.swift
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

final public class DashlineView: UIView {
    public var spacing: CGFloat = 2
    public var lineColor: UIColor = UIColor.separator
    public var horizontal: Bool = true
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        backgroundColor?.setFill()
        UIRectFill(rect)
        
        let lineWidth = horizontal ? rect.height.ceilling : rect.width.ceilling
        let startPoint = horizontal ? CGPoint(x: (lineWidth / 2).ceilling, y: (rect.height / 2).ceilling) :
                                      CGPoint(x: (rect.width / 2).ceilling , y: (lineWidth / 2).ceilling)
        let endPoint = horizontal ? CGPoint(x: rect.width - (lineWidth / 2).ceilling, y: (rect.height / 2).ceilling) :
                                    CGPoint(x: (rect.width / 2).ceilling , y: rect.height - (lineWidth / 2).ceilling)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        context.setLineDash(phase: 0, lengths: [spacing, spacing])
        context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        context.strokePath()
    }
}
