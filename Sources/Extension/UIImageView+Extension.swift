//
//  UIImageView+Extension.swift
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

public extension UIImageView {
    /// Setup rounding corners radius, fillColor will not be used.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame and image.
    public override func addRoundingCorners(
        for corners: UIRectCorner = .allCorners,
        radius: CGFloat = 3,
        fillColor: UIColor? = nil,
        strokeColor: UIColor? = nil,
        strokeLineWidth: CGFloat = 0)
    {
        if frame.size.equalTo(CGSize.zero) {
            logging("Could not set rounding corners on zero size view.")
            return
        }
        if nil != layer.contents {
            return
        }
        guard let image = image else {
            return
        }
        
        DispatchQueue.global().async {
            let scale = max(
                image.size.width / self.frame.size.width,
                image.size.height / self.frame.size.height
            )
            let relatedRadius = scale * radius
            let relatedStockLineWidth = scale * strokeLineWidth
            let newImage = image.remake(
                roundingCorners: corners,
                radius: relatedRadius,
                strokeColor: strokeColor ?? UIColor.clear,
                strokeLineWidth: relatedStockLineWidth
            )
            DispatchQueue.main.async {
                self.backgroundColor = UIColor.clear
                self.image = newImage
                self.isRoundingCornersExists = true
            }
        }
    }
}
