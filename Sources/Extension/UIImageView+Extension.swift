//
//  UIImageView+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 5/4/16.
//  Copyright © 2016 Moch Xiao (http://mochxiao.com).
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
    /// Setup rounding corners radius
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame and image.
    public override func setRoundingCorners(
        corners corners: UIRectCorner = .AllCorners,
        radius: CGFloat = 3,
        fillColor: UIColor = UIColor.whiteColor(),
        strokeColor: UIColor = UIColor.clearColor(),
        stockLineWidth: CGFloat = 1.0 / UIScreen.mainScreen().scale)
    {
        if CGSizeEqualToSize(frame.size, CGSize.zero) {
            debugPrint("Could not set rounding corners on zero size view.")
            return
        }
        if nil != layer.contents {
            return
        }
        guard let _image = image else { return }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let scale = max(_image.size.width / self.frame.size.width, _image.size.height / self.frame.size.height)
            let relatedRadius = scale * radius
            let relatedStockLineWidth = scale * stockLineWidth
            
            let newImage = _image.imageWith(roundingCorners: corners, radius: relatedRadius, strokeColor: strokeColor, stockLineWidth: relatedStockLineWidth)
            dispatch_async(dispatch_get_main_queue()) {
                self.backgroundColor = UIColor.clearColor()
                self.image = newImage
            }
        }
    }
}
