//
//  PaddingLabel.swift
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

// MARK: - PaddingLabel

final public class PaddingLabel: UILabel {
    fileprivate var contentEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 4)
    
    fileprivate init() {
        super.init(frame: CGRect.zero)
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(contentEdgeInsets: UIEdgeInsets) {
        self.init(frame: CGRect.zero)
        self.contentEdgeInsets = contentEdgeInsets
    }
    
    public override var intrinsicContentSize : CGSize {
        let size = sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
        let width = size.width + contentEdgeInsets.left + contentEdgeInsets.right
        let height = size.height + contentEdgeInsets.top + contentEdgeInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentEdgeInsets))
    }
}
