//
//  UIButton+Extension.swift
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

// MARK: - AssociationKey

private struct AssociationKey {
    fileprivate static var activityIndicatorContainerView: String = "com.mochxiao.uibutton.activityIndicatorContainerView"
}

// MARK: - Property for state

public extension Extension where Base: UIButton {
    public var title: String? {
        get { return base.title(for: .normal) }
        set { base.setTitle(newValue, for: .normal) }
    }
    
    public var titleFont: UIFont? {
        get { return base.titleLabel?.font }
        set { base.titleLabel?.font = newValue }
    }
    
    public var attributedTitle: NSAttributedString? {
        get { return base.attributedTitle(for: .normal) }
        set { base.setAttributedTitle(newValue, for: .normal) }
    }
    
    public var titleColor: UIColor? {
        get { return base.titleColor(for: .normal) }
        set {
            base.setTitleColor(newValue, for: .normal)
            base.setTitleColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            base.setTitleColor(newValue, for: .selected)
            if base.buttonType == .custom {
                base.setTitleColor(newValue?.withAlphaComponent(0.5), for: .highlighted)
            }
        }
    }
    
    public var titleShadowColor: UIColor? {
        get { return base.titleShadowColor(for: .normal) }
        set {
            base.setTitleShadowColor(newValue, for: .normal)
            base.setTitleShadowColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            base.setTitleShadowColor(newValue, for: .selected)
        }
    }
    
    public var image: UIImage? {
        get { return base.image(for: .normal) }
        set {
            base.setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    public var selectedImage: UIImage? {
        get { return base.image(for: .selected) }
        set { base.setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    public var backgroundImage: UIImage? {
        get { return base.backgroundImage(for: .normal) }
        set {
            let image = newValue?.withRenderingMode(.alwaysOriginal)
            base.setBackgroundImage(image, for: .normal)
            if base.buttonType == .custom {
                base.setBackgroundImage(image?.ext.remake(alpha: 0.5), for: .highlighted)
                base.setBackgroundImage(image?.ext.remake(alpha: 0.5), for: .disabled)
            }
        }
    }
    
    public var selectedBackgroundImage: UIImage? {
        get { return base.backgroundImage(for: .selected) }
        set { base.setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    public var disabledBackgroundImage: UIImage? {
        get { return base.backgroundImage(for: .disabled) }
        set { base.setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .disabled) }
    }
}

// MARK: - Image position

public extension Extension where Base: UIButton {
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
        guard let currentImage = base.currentImage else { return }
        guard let currentTitle = base.currentTitle as NSString? else { return }
        guard let titleLabel = base.titleLabel else { return }
        
        let halfSpace = (space / 2.0).ext.ceilling
        let halfImageWidth = (currentImage.size.width / 2.0).ext.ceilling
        let halfImageHeight = (currentImage.size.height / 2.0).ext.ceilling
        base.titleEdgeInsets = UIEdgeInsetsMake(
            halfImageHeight + halfSpace,
            -halfImageWidth,
            -halfImageHeight - halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ext.ceilling
        let halfEdgeWidth = (titleBounds.width / 2.0).ext.ceilling
        let halfEdgeHeight = (titleBounds.height / 2.0).ext.ceilling
        base.imageEdgeInsets = UIEdgeInsetsMake(
            -halfEdgeHeight - halfSpace,
            halfEdgeWidth,
            halfEdgeHeight + halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToBottom(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = base.currentImage else { return }
        guard let currentTitle = base.currentTitle as NSString? else { return }
        guard let titleLabel = base.titleLabel else { return }
        
        let halfSpace = (space / 2.0).ext.ceilling
        let halfImageWidth = (currentImage.size.width / 2.0).ext.ceilling
        let halfImageHeight = (currentImage.size.height / 2.0).ext.ceilling
        base.titleEdgeInsets = UIEdgeInsetsMake(
            -halfImageHeight - halfSpace,
            -halfImageWidth,
            halfImageHeight + halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ext.ceilling
        let halfEdgeWidth = (titleBounds.width / 2.0).ext.ceilling
        let halfEdgeHeight = (titleBounds.height / 2.0).ext.ceilling
        base.imageEdgeInsets = UIEdgeInsetsMake(
            halfEdgeHeight + halfSpace,
            halfEdgeWidth,
            -halfEdgeHeight - halfSpace,
            -halfEdgeWidth
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToLeft(titleSpace space: CGFloat = 4.0) {
        let halfSpace = (space / 2.0).ext.ceilling
        
        base.titleEdgeInsets = UIEdgeInsetsMake(
            0,
            halfSpace,
            0,
            -halfSpace
        )
        base.imageEdgeInsets = UIEdgeInsetsMake(
            0,
            -halfSpace,
            0,
            halfSpace
        )
    }
    
    /// Setup image position relate to title
    /// **NOTE**: Before invoke this methods you should setup title and image already
    public func setImageAlignmentToRight(titleSpace space: CGFloat = 4.0) {
        guard let currentImage = base.currentImage else { return }
        guard let currentTitle = base.currentTitle as NSString? else { return }
        guard let titleLabel = base.titleLabel else { return }
        
        let halfSpace = (space / 2.0).ext.ceilling
        let imageWidth = currentImage.size.width.ext.ceilling
        let edgeWidth = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).width.ext.ceilling
        
        base.titleEdgeInsets = UIEdgeInsetsMake(
            0,
            -imageWidth - halfSpace,
            0,
            imageWidth + halfSpace
        )
        base.imageEdgeInsets = UIEdgeInsetsMake(
            0,
            edgeWidth + halfSpace,
            0,
            -edgeWidth - halfSpace
        )
    }
}

// MARK: - Animation


public extension Extension where Base: UIButton {
    public fileprivate(set) var activityIndicatorContainerView: UIView? {
        get { return associatedObject(forKey: &AssociationKey.activityIndicatorContainerView) as? UIView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.activityIndicatorContainerView) }
    }
    
    public func startActivityIndicatorAnimation(indicatorColor color: UIColor = UIColor.lightGray, dy: CGFloat = 0) {
        if let activityIndicatorContainerView = self.activityIndicatorContainerView {
            if activityIndicatorContainerView.ext.isActivityIndicatorAnimating {
                return
            }
            activityIndicatorContainerView.isHidden = false
            activityIndicatorContainerView.ext.startActivityIndicatorAnimation(indicatorColor: color, dy: dy)
            return
        }
        
        var bgColor = base.backgroundColor
        if bgColor == nil, let backgroundImage = backgroundImage {
            bgColor = backgroundImage.ext.color(atPixel: CGPoint(x: backgroundImage.size.width / 2.0, y: backgroundImage.size.height / 2.0))
        }
        let activityIndicatorContainerView = UIView(frame: base.bounds)
        activityIndicatorContainerView.backgroundColor = bgColor
        activityIndicatorContainerView.isUserInteractionEnabled = false
        activityIndicatorContainerView.clipsToBounds = true
        activityIndicatorContainerView.ext.cornerRadius = cornerRadius
        activityIndicatorContainerView.ext.startActivityIndicatorAnimation(indicatorColor: color, dy: dy)
        base.addSubview(activityIndicatorContainerView)
        self.activityIndicatorContainerView = activityIndicatorContainerView
    }

    public func stopActivityIndicatorAnimation() {
        activityIndicatorContainerView?.ext.stopActivityIndicatorAnimation()
        activityIndicatorContainerView?.isHidden = true
    }
    
    public var isActivityIndicatorAnimating: Bool {
        if let activityIndicatorContainerView = activityIndicatorContainerView {
            return activityIndicatorContainerView.ext.isActivityIndicatorAnimating
        }
        return false
    }
}

// MARK: - 

public extension Extension where Base: UIButton {
    public func performToggleSelectStateImageAnimation() {
        guard let normalImage = base.image(for: .normal) else { return }
        guard let selectedImage = base.image(for: .selected) else { return }
        guard let _imageView = base.imageView else { return }
        
        // Clear image
        {
            base.setImage(nil, for: .normal)
            base.setImage(nil, for: .selected)
        }()
        
        let animatedImageView = UIImageView(image: base.isSelected ? selectedImage : normalImage)
        animatedImageView.frame = _imageView.frame
        base.addSubview(animatedImageView)
        
        let recover = {
            UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                animatedImageView.transform = CGAffineTransform.identity
            }, completion: { (finished: Bool) in
                self.base.setImage(normalImage, for: .normal)
                self.base.setImage(selectedImage, for: .selected)
                self.base.isSelected = !self.base.isSelected
                animatedImageView.removeFromSuperview()
            })
        }
        
        let zoomOut = {
            animatedImageView.image = !self.base.isSelected ? selectedImage : normalImage
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
