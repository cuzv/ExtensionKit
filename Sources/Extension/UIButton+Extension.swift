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
    fileprivate static var isIndicatorAnimating: String = "UIButton_isIndicatorAnimating"
    fileprivate static var context: String = "UIButton_animation_context"
}

// MARK: - Property for state

public extension UIButton {
    public var title: String? {
        get { return self.title(for: UIControlState()) }
        set { setTitle(newValue, for: UIControlState()) }
    }
    
    public var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    public var attributedTitle: NSAttributedString? {
        get { return self.attributedTitle(for: UIControlState()) }
        set { setAttributedTitle(newValue, for: UIControlState()) }
    }
    
    public var titleColor: UIColor? {
        get { return self.titleColor(for: UIControlState()) }
        set {
            setTitleColor(newValue, for: UIControlState())
            setTitleColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            setTitleColor(newValue, for: .selected)
            if buttonType == .custom {
                setTitleColor(newValue?.withAlphaComponent(0.5), for: .highlighted)
            }
        }
    }
    
    public var titleShadowColor: UIColor? {
        get { return self.titleShadowColor(for: UIControlState()) }
        set {
            setTitleShadowColor(newValue, for: UIControlState())
            setTitleShadowColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            setTitleShadowColor(newValue, for: .selected)
        }
    }
    
    public var image: UIImage? {
        get { return self.image(for: UIControlState()) }
        set {
            setImage(newValue?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        }
    }
    
    public var selectedImage: UIImage? {
        get { return self.image(for: .selected) }
        set { setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    public var backgroundImage: UIImage? {
        get { return self.backgroundImage(for: UIControlState()) }
        set {
            let image = newValue?.withRenderingMode(.alwaysOriginal)
            setBackgroundImage(image, for: UIControlState())
            if buttonType == .custom {
                setBackgroundImage(image?.imgeWithAlpha(0.5), for: .highlighted)
                setBackgroundImage(image?.imgeWithAlpha(0.5), for: .disabled)
            }
        }
    }
    
    public var selectedBackgroundImage: UIImage? {
        get { return self.backgroundImage(for: .selected) }
        set { setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    public var disabledBackgroundImage: UIImage? {
        get { return self.backgroundImage(for: .disabled) }
        set { setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .disabled) }
    }
}

// MARK: - Image position

public extension UIButton {
    /// Convenience `setImageAlignmentToTop:` setter.
    public var imageAlignmentTopSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToTop(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToLeft:` setter.
    public var imageAlignmentLeftSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToLeft(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToBottom:` setter.
    public var imageAlignmentBottomSpace: CGFloat {
        get { fatalError("Unavailable.") }
        set { setImageAlignmentToBottom(titleSpace: newValue) }
    }
    
    /// Convenience `setImageAlignmentToRight:` setter.
    public var imageAlignmentRightSpace: CGFloat {
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
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ceilly
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
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ceilly
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
        let edgeWidth = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).width.ceilly
        
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
    fileprivate var _isIndicatorAnimating: Bool? {
        get { return associatedObject(forKey: &AssociationKey.isIndicatorAnimating) as? Bool }
        set { associate(retainObject: newValue as AnyObject!, forKey: &AssociationKey.isIndicatorAnimating) }
    }
    
    fileprivate var context: [String: AnyObject] {
        get { return associatedObject(forKey: &AssociationKey.context) as! [String: AnyObject] }
        set { associate(retainObject: newValue as AnyObject!, forKey: &AssociationKey.context) }
    }
    
    public func startIndicatorAnimating() {
        if isIndicatorAnimating {
            return
        }
        
        isEnabled = false
        
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
        
        isEnabled = true
    }
    
    public var isIndicatorAnimating: Bool {
        if let _isIndicatorAnimating = _isIndicatorAnimating {
            return _isIndicatorAnimating
        }
        return false
    }
    
    fileprivate func _context() -> [String: AnyObject] {
        var context: [String: AnyObject] = [String: AnyObject]()
        
        if let normalimage = self.image(for: UIControlState()) {
            context["normalimage"] = normalimage
        }
        if let highlightedImage = self.image(for: .highlighted) {
            context["highlightedImage"] = highlightedImage
        }
        if let selectedImage = self.image(for: .selected) {
            context["selectedImage"] = selectedImage
        }
        
        if let normalBackgroundImage = self.backgroundImage(for: UIControlState()) {
            context["normalBackgroundImage"] = normalBackgroundImage
        }
        if let highlightedBackgroundImage = self.backgroundImage(for: .highlighted) {
            context["highlightedBackgroundImage"] = highlightedBackgroundImage
        }
        if let selectedBackgroundImage = self.backgroundImage(for: .selected) {
            context["selectedBackgroundImage"] = selectedBackgroundImage
        }
        
        if let normalTitle = self.title(for: UIControlState()) {
            context["normalTitle"] = normalTitle as AnyObject?
        }
        if let highlightedTitle = self.title(for: .highlighted) {
            context["highlightedTitle"] = highlightedTitle as AnyObject?
        }
        if let selectedTitle = self.title(for: .selected) {
            context["selectedTitle"] = selectedTitle as AnyObject?
        }
        
        if let backgroundColor = backgroundColor {
            context["backgroundColor"] = backgroundColor
        }
        return context
    }
    
    fileprivate func _clearProperties() {
        setImage(nil, for: UIControlState())
        setImage(nil, for: .highlighted)
        setImage(nil, for: .selected)
        
        setBackgroundImage(nil, for: UIControlState())
        setBackgroundImage(nil, for: .highlighted)
        setBackgroundImage(nil, for: .selected)
        
        setTitle(nil, for: UIControlState())
        setTitle(nil, for: .highlighted)
        setTitle(nil, for: .selected)
        
        backgroundColor = nil
    }
    
    fileprivate func _addAnimation() {
        let indicator = _ButtonAnimationUIActivityIndicatorView(activityIndicatorStyle: .gray)
        let length = floor(bounds.height * 0.8)
        indicator.bounds = CGRect(x: 0, y: 0, width: length, height: length)
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicator.backgroundColor = UIColor.clear
        indicator.startAnimating()
        addSubview(indicator)
        _isIndicatorAnimating = true
    }
    
    fileprivate func _removeAnimation() {
        for sub in subviews {
            if sub.isMember(of: _ButtonAnimationUIActivityIndicatorView.self) {
                let indicator = sub as! _ButtonAnimationUIActivityIndicatorView
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                _isIndicatorAnimating = false
                return
            }
        }
    }
    
    fileprivate func _recoverProperties() {
        if let normalimage = context["normalimage"] as? UIImage {
            setImage(normalimage, for: UIControlState())
        }
        if let highlightedImage = context["highlightedImage"] as? UIImage {
            setImage(highlightedImage, for: .highlighted)
        }
        if let selectedImage = context["selectedImage"] as? UIImage {
            setImage(selectedImage, for: .highlighted)
        }
        
        if let normalBackgroundImage = context["normalBackgroundImage"] as? UIImage {
            setBackgroundImage(normalBackgroundImage, for: UIControlState())
        }
        if let highlightedBackgroundImage = context["highlightedBackgroundImage"] as? UIImage {
            setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        }
        if let selectedBackgroundImage = context["selectedBackgroundImage"] as? UIImage {
            setBackgroundImage(selectedBackgroundImage, for: .selected)
        }
        
        if let normalTitle = context["normalTitle"] as? String {
            setTitle(normalTitle, for: UIControlState())
        }
        if let highlightedTitle = context["highlightedTitle"] as? String {
            setTitle(highlightedTitle, for: .highlighted)
        }
        if let selectedTitle = context["selectedTitle"] as? String {
            setTitle(selectedTitle, for: .selected)
        }
        
        if let bgColor = context["backgroundColor"] as? UIColor {
            backgroundColor = bgColor
        }
    }
    
    public func performToggleSelectStateImageAnimation() {
        guard let normalImage = self.image(for: UIControlState()) else { return }
        guard let selectedImage = self.image(for: .selected) else { return }
        guard let _imageView = imageView else { return }
        
        // Clear image
        {
            setImage(nil, for: UIControlState())
            setImage(nil, for: .selected)
        }()
        
        let animatedImageView = UIImageView(image: isSelected ? selectedImage : normalImage)
        animatedImageView.frame = _imageView.frame
        addSubview(animatedImageView)
        
        let recover = {
            UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                animatedImageView.transform = CGAffineTransform.identity
            }, completion: { (finished: Bool) in
                self.setImage(normalImage, for: UIControlState())
                self.setImage(selectedImage, for: .selected)
                self.isSelected = !self.isSelected
                animatedImageView.removeFromSuperview()
            })
        }
        
        let zoomOut = {
            animatedImageView.image = !self.isSelected ? selectedImage : normalImage
            UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                animatedImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (finished: Bool) in
                recover()
            })
        }
        
        // Start with zoom in
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            animatedImageView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }, completion: { (finished: Bool) in
            zoomOut()
        })
    }
}
