//
//  UIButton+Extension.swift
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

// MARK: - Property for state

@IBDesignable
public extension UIButton {
    @IBInspectable public var title: String? {
        get { return titleForState(.Normal) }
        set { setTitle(newValue, forState: .Normal) }
    }
    
    @IBInspectable public var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    @IBInspectable public var attributedTitle: NSAttributedString? {
        get { return attributedTitleForState(.Normal) }
        set { setAttributedTitle(newValue, forState: .Normal) }
    }
    
    @IBInspectable public var titleColor: UIColor? {
        get { return titleColorForState(.Normal) }
        set {
            setTitleColor(newValue, forState: .Normal)
            setTitleColor(newValue?.colorWithAlphaComponent(0.5), forState: .Disabled)
            setTitleColor(newValue, forState: .Selected)
            if buttonType == .Custom {
                setTitleColor(newValue?.colorWithAlphaComponent(0.5), forState: .Highlighted)
            }
        }
    }
    
    @IBInspectable public var titleShadowColor: UIColor? {
        get { return titleShadowColorForState(.Normal) }
        set {
            setTitleShadowColor(newValue, forState: .Normal)
            setTitleShadowColor(newValue?.colorWithAlphaComponent(0.5), forState: .Disabled)
            setTitleShadowColor(newValue, forState: .Selected)
        }
    }
    
    @IBInspectable public var image: UIImage? {
        get { return imageForState(.Normal) }
        set {
            setImage(newValue?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        }
    }
    
    @IBInspectable public var selectedImage: UIImage? {
        get { return imageForState(.Selected) }
        set { setImage(newValue?.imageWithRenderingMode(.AlwaysOriginal), forState: .Selected) }
    }
    
    @IBInspectable public var backgroundImage: UIImage? {
        get { return backgroundImageForState(.Normal) }
        set {
            let image = newValue?.imageWithRenderingMode(.AlwaysOriginal)
            setBackgroundImage(image, forState: .Normal)
            if buttonType == .Custom {
                setBackgroundImage(image?.imgeWithAlpha(0.5), forState: .Highlighted)
                setBackgroundImage(image?.imgeWithAlpha(0.5), forState: .Disabled)
            }
        }
    }
    
    @IBInspectable public var selectedBackgroundImage: UIImage? {
        get { return backgroundImageForState(.Selected) }
        set { setBackgroundImage(newValue?.imageWithRenderingMode(.AlwaysOriginal), forState: .Selected) }
    }
    
    @IBInspectable public var disabledBackgroundImage: UIImage? {
        get { return backgroundImageForState(.Disabled) }
        set { setBackgroundImage(newValue?.imageWithRenderingMode(.AlwaysOriginal), forState: .Disabled) }
    }
}

// MARK: - Image position

@IBDesignable
public extension UIButton {
    /// Convenience `setImageAlignmentToTop:` setter.
    @IBInspectable public var imageAlignmentTopSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToTop(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToLeft:` setter.
    @IBInspectable public var imageAlignmentLeftSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToLeft(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToBottom:` setter.
    @IBInspectable public var imageAlignmentBottomSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToBottom(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToRight:` setter.
    @IBInspectable public var imageAlignmentRightSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToRight(titleSpace: newValue) }
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup and title image already
    public func setImageAlignmentToTop(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = space / 2.0
        let halfImageWidth = currentImage.size.width / 2.0
        let halfImageHeight = currentImage.size.height / 2.0
        titleEdgeInsets = UIEdgeInsetsMake(
            halfImageHeight + halfSpace,
            -halfImageWidth,
            -halfImageHeight - halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font])
        let halfEdgeWidth = titleBounds.width / 2.0
        let halfEdgeHeight = titleBounds.height / 2.0
        imageEdgeInsets = UIEdgeInsetsMake(
            -halfEdgeHeight - halfSpace,
            halfEdgeWidth,
            halfEdgeHeight + halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup and title image already
    public func setImageAlignmentToBottom(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = space / 2.0
        let halfImageWidth = currentImage.size.width / 2.0
        let halfImageHeight = currentImage.size.height / 2.0
        titleEdgeInsets = UIEdgeInsetsMake(
            -halfImageHeight - halfSpace,
            -halfImageWidth,
            halfImageHeight + halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font])
        let halfEdgeWidth = titleBounds.width / 2.0
        let halfEdgeHeight = titleBounds.height / 2.0
        imageEdgeInsets = UIEdgeInsetsMake(
            halfEdgeHeight + halfSpace,
            halfEdgeWidth,
            -halfEdgeHeight - halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup and title image already
    public func setImageAlignmentToLeft(titleSpace space: CGFloat = 4.0) {
        let halfSpace = space / 2.0
        
        titleEdgeInsets = UIEdgeInsetsMake(
            0,
            halfSpace,
            0,
            -halfSpace
        )
        imageEdgeInsets = UIEdgeInsetsMake(
            0,
            -halfSpace,
            0,
            halfSpace
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup and title image already
    public func setImageAlignmentToRight(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = space / 2.0
        let imageWidth = currentImage.size.width
        let edgeWidth = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font]).width
        
        titleEdgeInsets = UIEdgeInsetsMake(
            0,
            -imageWidth - halfSpace,
            0,
            imageWidth + halfSpace
        )
        imageEdgeInsets = UIEdgeInsetsMake(
            0,
            edgeWidth + halfSpace,
            0,
            -edgeWidth - halfSpace
        )
    }
}
