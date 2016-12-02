//
//  UILabel+Extension.swift
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

private struct AssociationKey {
    fileprivate static var contentInsets: String = "com.mochxiao.uilabel.contentInsets"
}

// MARK: - Swizzle

extension UILabel {
    override open class func initialize() {
        if self != UILabel.self {
            return
        }
        swizzleInstanceMethod(
            for: UILabel.self,
            original: #selector(getter: intrinsicContentSize),
            override: #selector(getter: _ek_intrinsicContentSize)
        )
        swizzleInstanceMethod(
            for: UILabel.self,
            original: #selector(drawText(in:)),
            override: #selector(_ek_drawText(in:))
        )
    }
    
    var _ek_intrinsicContentSize: CGSize {
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: bounds.size.height))
        let width = size.width + ext.contentInsets.left + ext.contentInsets.right
        let height = size.height + ext.contentInsets.top + ext.contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    func _ek_drawText(in rect: CGRect) {
        _ek_drawText(in: UIEdgeInsetsInsetRect(rect, ext.contentInsets))
    }
}

public extension Extension where Base: UILabel {
    public var contentInsets: UIEdgeInsets {
        get {
            if let value = associatedObject(forKey: &AssociationKey.contentInsets) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            return UIEdgeInsets.zero
        }
        set { associate(retainObject: NSValue(uiEdgeInsets: newValue), forKey: &AssociationKey.contentInsets) }
    }
}

// MARK: - 

public extension Extension where Base: UILabel {
    /// Setup rounding corners radius.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame and image.
    public func addRoundingCorners(
        for corners: UIRectCorner = .allCorners,
        radius: CGFloat = 3,
        fillColor: UIColor? = nil,
        strokeColor: UIColor? = nil,
        strokeLineWidth: CGFloat = 0)
    {
        if base.frame.size.equalTo(CGSize.zero) {
            logging("Could not set rounding corners on zero size view.")
            return
        }
        if nil == base.superview {
            return
        }

        DispatchQueue.global().async {
            let backImage = UIImage.ext.make(
                color: fillColor ?? self.base.backgroundColor ?? UIColor.white,
                size: self.base.frame.size,
                roundingCorners: corners,
                radius: radius,
                strokeColor: strokeColor ?? self.base.backgroundColor ?? UIColor.clear,
                strokeLineWidth: strokeLineWidth
            )
            DispatchQueue.main.async {
                let backImageView = UIImageView(image: backImage)
                backImageView.frame = self.base.frame
                self.base.superview?.addSubview(backImageView)
                self.base.superview?.sendSubview(toBack: backImageView)
                self.base.backgroundColor = UIColor.clear
                self.isRoundingCornersExists = true
            }
        }
    }
    
    /// This will remove all added rounding corners on label's superview
    public func removeRoundingCorners() {
        base.superview?.ext.removeRoundingCorners()
        isRoundingCornersExists = false
    }
}

