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
                setBackgroundImage(image?.remake(alpha: 0.5), for: .highlighted)
                setBackgroundImage(image?.remake(alpha: 0.5), for: .disabled)
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
        
        let halfSpace = (space / 2.0).ceilling
        let halfImageWidth = (currentImage.size.width / 2.0).ceilling
        let halfImageHeight = (currentImage.size.height / 2.0).ceilling
        titleEdgeInsets = UIEdgeInsetsMake(
            halfImageHeight + halfSpace,
            -halfImageWidth,
            -halfImageHeight - halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ceilling
        let halfEdgeWidth = (titleBounds.width / 2.0).ceilling
        let halfEdgeHeight = (titleBounds.height / 2.0).ceilling
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
        
        let halfSpace = (space / 2.0).ceilling
        let halfImageWidth = (currentImage.size.width / 2.0).ceilling
        let halfImageHeight = (currentImage.size.height / 2.0).ceilling
        titleEdgeInsets = UIEdgeInsetsMake(
            -halfImageHeight - halfSpace,
            -halfImageWidth,
            halfImageHeight + halfSpace,
            halfImageWidth
        )
        
        let titleBounds = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).ceilling
        let halfEdgeWidth = (titleBounds.width / 2.0).ceilling
        let halfEdgeHeight = (titleBounds.height / 2.0).ceilling
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
        let halfSpace = (space / 2.0).ceilling
        
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
        
        let halfSpace = (space / 2.0).ceilling
        let imageWidth = currentImage.size.width.ceilling
        let edgeWidth = currentTitle.size(attributes: [NSFontAttributeName: titleLabel.font]).width.ceilling
        
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


public extension UIButton {
    public fileprivate(set) var activityIndicatorContainerView: UIView? {
        get { return associatedObject(forKey: &AssociationKey.activityIndicatorContainerView) as? UIView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.activityIndicatorContainerView) }
    }
    
    public override func satrtActivityIndicatorAnimation(indicatorColor color: UIColor = UIColor.lightGray, dy: CGFloat = 0) {
        if let activityIndicatorContainerView = activityIndicatorContainerView {
            if activityIndicatorContainerView.isActivityIndicatorAnimating {
                return
            }
            activityIndicatorContainerView.isHidden = false
            activityIndicatorContainerView.satrtActivityIndicatorAnimation(indicatorColor: color, dy: dy)
            return
        }
        
        var bgColor = backgroundColor
        if bgColor == nil, let backgroundImage = backgroundImage {
            bgColor = backgroundImage.color(atPixel: CGPoint(x: backgroundImage.size.width / 2.0, y: backgroundImage.size.height / 2.0))
        }
        let _activityIndicatorContainerView = UIView(frame: bounds)
        _activityIndicatorContainerView.backgroundColor = bgColor
        _activityIndicatorContainerView.isUserInteractionEnabled = false
        _activityIndicatorContainerView.clipsToBounds = true
        _activityIndicatorContainerView.cornerRadius = cornerRadius
        _activityIndicatorContainerView.satrtActivityIndicatorAnimation(indicatorColor: color, dy: dy)
        addSubview(_activityIndicatorContainerView)
        activityIndicatorContainerView = _activityIndicatorContainerView
    }

    public override func stopActivityIndicatorAnimation() {
        activityIndicatorContainerView?.stopActivityIndicatorAnimation()
        activityIndicatorContainerView?.isHidden = true
    }
    
    public override var isActivityIndicatorAnimating: Bool {
        if let activityIndicatorContainerView = activityIndicatorContainerView {
            return activityIndicatorContainerView.isActivityIndicatorAnimating
        }
        return false
    }
}

// MARK: - 

public extension UIButton {
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
