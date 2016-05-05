//
//  UILabel+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
//  Copyright © @2015 Moch Xiao (https://github.com/cuzv).
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

private class _LabelBackgroundImageView: UIImageView {}

public extension UILabel {
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

        if let superview = superview {
            for sub in superview.subviews {
                if sub.isMemberOfClass(_LabelBackgroundImageView.self) {
                    return
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let backImage = UIImageFrom(
                color: fillColor,
                size: self.frame.size,
                roundingCorners: corners,
                radius: radius,
                strokeColor: strokeColor,
                stockLineWidth: stockLineWidth
            )
            
            dispatch_async(dispatch_get_main_queue()) {
                let backImageView = _LabelBackgroundImageView(image: backImage)
                backImageView.frame = self.frame
                self.superview?.addSubview(backImageView)
                self.superview?.sendSubviewToBack(backImageView)

                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
}

