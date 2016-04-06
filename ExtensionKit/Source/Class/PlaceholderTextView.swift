//
//  PlaceholderTextView.swift
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

/// The UITextView subclass supported a placeholder property like UITextField.
/// Optional has a counting remain text length present label.
/// **Note**: Do not forget invoke `invokeTextObserver(maxLength:, actionHandler:)`.
@IBDesignable
final public class PlaceholderTextView: UITextView {
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.placeholderColor
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        label.lineBreakMode = .ByTruncatingTail
        label.numberOfLines = 0
        return label
    }()
    
    @IBInspectable public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholderLabelFrame()
        }
    }
    
    @IBInspectable override public var font: UIFont! {
        didSet {
            placeholderLabel.font = font
            updatePlaceholderLabelFrame()
        }
    }
    
    @IBInspectable override public var text: String? {
        didSet {
            if let text = text where text.length > 0 {
                placeholderLabel.hidden = true
            } else {
                placeholderLabel.hidden = false
            }
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePlaceholderLabelFrame()
    }
}

public extension PlaceholderTextView {
    private func setup() {
        addSubview(placeholderLabel)
    }
    
    private func updatePlaceholderLabelFrame() {
        if let size = placeholderLabel.text?.size(withFont: placeholderLabel.font, preferredMaxLayoutWidth: CGRectGetWidth(bounds) - 10) {
            placeholderLabel.frame = CGRectMake(5, 4, size.width + 10, size.height + 8)
        }
    }
    
    /// **Note**: Do not invoke `setupTextObserver(maxLength:, actionHandler:)` the both.
    public func invokeTextObserver(maxLength maxLength: Int = 100, actionHandler: ((Int) -> ())? = nil) {
        setupTextObserver(maxLength: maxLength) { [weak self] (remainCount) -> () in
            self?.placeholderLabel.hidden = remainCount != maxLength
            actionHandler?(remainCount)
        }
    }
}
