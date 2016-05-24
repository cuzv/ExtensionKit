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

// MARK: - AssociationKey

private struct AssociationKey {
    private static var isIndicatorAnimating: String = "UIButton_isIndicatorAnimating"
    private static var context: String = "UIButton_animation_context"
}

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
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToTop(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = (space / 2.0).ceilly
        let halfImageWidth = (currentImage.size.width / 2.0).ceilly
        let halfImageHeight = (currentImage.size.height / 2.0).ceilly
        titleEdgeInsets = UIEdgeInsetsMake(
            halfImageHeight + halfSpace,
            -halfImageWidth,
            -halfImageHeight - halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font]).ceilly
        let halfEdgeWidth = (titleBounds.width / 2.0).ceilly
        let halfEdgeHeight = (titleBounds.height / 2.0).ceilly
        imageEdgeInsets = UIEdgeInsetsMake(
            -halfEdgeHeight - halfSpace,
            halfEdgeWidth,
            halfEdgeHeight + halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToBottom(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = (space / 2.0).ceilly
        let halfImageWidth = (currentImage.size.width / 2.0).ceilly
        let halfImageHeight = (currentImage.size.height / 2.0).ceilly
        titleEdgeInsets = UIEdgeInsetsMake(
            -halfImageHeight - halfSpace,
            -halfImageWidth,
            halfImageHeight + halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font]).ceilly
        let halfEdgeWidth = (titleBounds.width / 2.0).ceilly
        let halfEdgeHeight = (titleBounds.height / 2.0).ceilly
        imageEdgeInsets = UIEdgeInsetsMake(
            halfEdgeHeight + halfSpace,
            halfEdgeWidth,
            -halfEdgeHeight - halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToLeft(titleSpace space: CGFloat = 4.0) {
        let halfSpace = (space / 2.0).ceilly
        
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
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToRight(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = currentImage else { return }
        guard let currentTitle = currentTitle as NSString? else { return }
        guard let titleLabel = titleLabel else { return }
        
        let halfSpace = (space / 2.0).ceilly
        let imageWidth = currentImage.size.width.ceilly
        let edgeWidth = currentTitle.sizeWithAttributes([NSFontAttributeName: titleLabel.font]).width.ceilly
        
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

// MARK: - Animation

private class _ButtonAnimationUIActivityIndicatorView: UIActivityIndicatorView {}

public extension UIButton {
    private var _isIndicatorAnimating: Bool? {
        get { return associatedObject(forKey: &AssociationKey.isIndicatorAnimating) as? Bool }
        set { associate(retainObject: newValue, forKey: &AssociationKey.isIndicatorAnimating) }
    }
    
    private var context: [String: AnyObject] {
        get { return associatedObject(forKey: &AssociationKey.context) as! [String: AnyObject] }
        set { associate(retainObject: newValue, forKey: &AssociationKey.context) }
    }
    
    public func startIndicatorAnimating() {
        if isIndicatorAnimating {
            return
        }
        
        enabled = false
        
        // 保存上下文
        context = _context()
        // 清除之前的设置
        _clearProperties()
        // 添加动画
        _addAnimation()
    }
    
    public func stopIndicatorAnimating() {
        if !isIndicatorAnimating {
            return
        }
        
        // 移除动画
        _removeAnimation()
        // 恢复之前设置的属性
        _recoverProperties()
        // 清除上下文
        context = [:]
        
        enabled = true
    }
    
    public var isIndicatorAnimating: Bool {
        if let _isIndicatorAnimating = _isIndicatorAnimating {
            return _isIndicatorAnimating
        }
        return false
    }
    
    private func _context() -> [String: AnyObject] {
        var context: [String: AnyObject] = [String: AnyObject]()
        
        if let normalimage = imageForState(.Normal) {
            context["normalimage"] = normalimage
        }
        if let highlightedImage = imageForState(.Highlighted) {
            context["highlightedImage"] = highlightedImage
        }
        if let selectedImage = imageForState(.Selected) {
            context["selectedImage"] = selectedImage
        }
        
        if let normalBackgroundImage = backgroundImageForState(.Normal) {
            context["normalBackgroundImage"] = normalBackgroundImage
        }
        if let highlightedBackgroundImage = backgroundImageForState(.Highlighted) {
            context["highlightedBackgroundImage"] = highlightedBackgroundImage
        }
        if let selectedBackgroundImage = backgroundImageForState(.Selected) {
            context["selectedBackgroundImage"] = selectedBackgroundImage
        }
        
        if let normalTitle = titleForState(.Normal) {
            context["normalTitle"] = normalTitle
        }
        if let highlightedTitle = titleForState(.Highlighted) {
            context["highlightedTitle"] = highlightedTitle
        }
        if let selectedTitle = titleForState(.Selected) {
            context["selectedTitle"] = selectedTitle
        }
        
        if let backgroundColor = backgroundColor {
            context["backgroundColor"] = backgroundColor
        }
        return context
    }
    
    private func _clearProperties() {
        setImage(nil, forState: .Normal)
        setImage(nil, forState: .Highlighted)
        setImage(nil, forState: .Selected)
        
        setBackgroundImage(nil, forState: .Normal)
        setBackgroundImage(nil, forState: .Highlighted)
        setBackgroundImage(nil, forState: .Selected)
        
        setTitle(nil, forState: .Normal)
        setTitle(nil, forState: .Highlighted)
        setTitle(nil, forState: .Selected)
        
        backgroundColor = nil
    }
    
    private func _addAnimation() {
        let indicator = _ButtonAnimationUIActivityIndicatorView(activityIndicatorStyle: .Gray)
        let length = floor(CGRectGetHeight(bounds) * 0.8)
        indicator.bounds = CGRectMake(0, 0, length, length)
        indicator.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        indicator.backgroundColor = UIColor.clearColor()
        indicator.startAnimating()
        addSubview(indicator)
        _isIndicatorAnimating = true
    }
    
    private func _removeAnimation() {
        for sub in subviews {
            if sub.isMemberOfClass(_ButtonAnimationUIActivityIndicatorView.self) {
                let indicator = sub as! _ButtonAnimationUIActivityIndicatorView
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                _isIndicatorAnimating = false
                return
            }
        }
    }
    
    private func _recoverProperties() {
        if let normalimage = context["normalimage"] as? UIImage {
            setImage(normalimage, forState: .Normal)
        }
        if let highlightedImage = context["highlightedImage"] as? UIImage {
            setImage(highlightedImage, forState: .Highlighted)
        }
        if let selectedImage = context["selectedImage"] as? UIImage {
            setImage(selectedImage, forState: .Highlighted)
        }
        
        if let normalBackgroundImage = context["normalBackgroundImage"] as? UIImage {
            setBackgroundImage(normalBackgroundImage, forState: .Normal)
        }
        if let highlightedBackgroundImage = context["highlightedBackgroundImage"] as? UIImage {
            setBackgroundImage(highlightedBackgroundImage, forState: .Highlighted)
        }
        if let selectedBackgroundImage = context["selectedBackgroundImage"] as? UIImage {
            setBackgroundImage(selectedBackgroundImage, forState: .Selected)
        }
        
        if let normalTitle = context["normalTitle"] as? String {
            setTitle(normalTitle, forState: .Normal)
        }
        if let highlightedTitle = context["highlightedTitle"] as? String {
            setTitle(highlightedTitle, forState: .Highlighted)
        }
        if let selectedTitle = context["selectedTitle"] as? String {
            setTitle(selectedTitle, forState: .Selected)
        }
        
        if let bgColor = context["backgroundColor"] as? UIColor {
            backgroundColor = bgColor
        }
    }
    
    public func performToggleSelectStateImageAnimation() {
        guard let normalImage = imageForState(.Normal) else { return }
        guard let selectedImage = imageForState(.Selected) else { return }
        guard let _imageView = imageView else { return }
        
        // Clear image
        {
            setImage(nil, forState: .Normal)
            setImage(nil, forState: .Selected)
        }()
        
        let animatedImageView = UIImageView(image: selected ? selectedImage : normalImage)
        animatedImageView.frame = _imageView.frame
        addSubview(animatedImageView)
        
        let recover = {
            UIView.animateWithDuration(0.2, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                animatedImageView.transform = CGAffineTransformIdentity
            }, completion: { (finished: Bool) in
                self.setImage(normalImage, forState: .Normal)
                self.setImage(selectedImage, forState: .Selected)
                self.selected = !self.selected
                animatedImageView.removeFromSuperview()
            })
        }
        
        let zoomOut = {
            animatedImageView.image = !self.selected ? selectedImage : normalImage
            UIView.animateWithDuration(0.2, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                animatedImageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion: { (finished: Bool) in
                recover()
            })
        }
        
        // Start with zoom in
        UIView.animateWithDuration(0.2, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
            animatedImageView.transform = CGAffineTransformMakeScale(1.7, 1.7)
        }, completion: { (finished: Bool) in
            zoomOut()
        })
    }
}