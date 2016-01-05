//
//  UIImage+Vendor.swift
//  MicroShop
//
//  Created by Moch Xiao on 12/21/15.
//  Copyright © 2015 Moch Xiao (https://github.com/cuzv).
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
import Kingfisher
import Toucan

public extension UIImage {
    /// Crop will resize to fit one dimension, then crop the other.
    public func cropResize(size: CGSize) -> UIImage {
        return Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Crop).image
    }
    
    /// Clip will resize so one dimension is equal to the size, the other shrunk down to retain aspect ratio.
    public func clipResize(size: CGSize) -> UIImage {
        return Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Clip).image
    }
    
    /// Scale will resize so the image fits exactly, altering the aspect ratio.
    public func scaleResize(size: CGSize) -> UIImage {
        return Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Scale).image
    }
    
    /// Demonstrate creating a circular mask -> resizes to a square image then mask with an ellipse.
    /// Mask with borders too!
    public func maskWithEllipse(
        borderWidth borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.whiteColor()) -> UIImage
    {
        return Toucan(image: self).maskWithEllipse(borderWidth: borderWidth, borderColor: borderColor).image
    }
    
    /// Rounded Rects are all in style.
    /// And can be fancy with borders.
    public func maskWithRoundedRect(
        cornerRadius cornerRadius: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.whiteColor()) -> UIImage
    {
        return Toucan(image: self).maskWithRoundedRect(cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor).image
    }
    
    /// Masking with an custom image mask.
    public func maskWithImage(maskImage: UIImage)  -> UIImage {
        return Toucan(image: self).maskWithImage(maskImage: maskImage).image
    }
}

public extension UIImageView {
    /// Set a crop resize image With a URLPath, a optional placeholder image.
    public func setCropResizeImageWithURLPath(URLPath: String, placeholderImage: UIImage? = nil) {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            $0?.cropResize($1)
        }
    }
    
    /// Set a clip resize image With a URLPath, a optional placeholder image.
    public func setClipResizeImageWithURLPath(URLPath: String, placeholderImage: UIImage? = nil) {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            $0?.clipResize($1)
        }
    }
    
    /// Set a clip resize image With a URLPath, a optional placeholder image.
    public func setScaleResizeImageWithURLPath(URLPath: String, placeholderImage: UIImage? = nil) {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            $0?.scaleResize($1)
        }
    }
    
    /// Set ellipse image with a URLPath, a optional placeholder image, optional border width, optional border color.
    public func setEllipseImageWithURLPath(
        URLPath: String,
        placeholderImage: UIImage? = nil,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.whiteColor())
    {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            [weak self] (image, error, imageURL) -> Void in
            
            guard let this = self else { return }
            this.image = image?.maskWithEllipse(borderWidth: borderWidth, borderColor: borderColor)
        }
    }
    
    /// Set rounded image with a URLPath, a optional placeholder image, optional corner radius, optional border width, optional border color.
    public func setRoundedImageWithURLPath(
        URLPath: String, placeholderImage: UIImage? = nil,
        cornerRadius: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.whiteColor())
    {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            [weak self] (image, error, imageURL) -> Void in
            
            guard let this = self else { return }
            this.image = image?.maskWithRoundedRect(cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
        }
    }
    
    /// Set image with a URLPath, a optional placeholder image, an custom image mask.
    public func setImageWithURLPath(
        URLPath: String,
        placeholderImage: UIImage? = nil,
        maskImage: UIImage)
    {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            [weak self] (image, error, imageURL) -> Void in
            
            guard let this = self else { return }
            this.image = image?.maskWithImage(maskImage)
        }
    }
    
    // MARK: -
    
    /// Set an image with a URLPath, a placeholder image.
    public func setImageWithURLPath(URLPath: String, placeholderImage: UIImage? = nil) {
        guard let URL = NSURL(string: URLPath) else { return }
        kf_setImageWithURL(URL, placeholderImage: placeholderImage, optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
    }
    
    /// Set an image with a URLPath, a placeholder image, a reduceSize closure.
    public func setImageWithURLPath(
        URLPath: String,
        placeholderImage: UIImage? = nil,
        reduceSize: (image: UIImage?, size: CGSize) -> UIImage?)
    {
        setImageWithURLPath(URLPath, placeholderImage: placeholderImage) {
            [weak self] (image, error, imageURL) -> Void in
            
            guard let this = self else { return }
            this.image = reduceSize(image: image, size: this.bounds.size)
        }
    }
    
    /// Set an image with a URLPath, a placeholder image, progressBlock, completion handler.
    public func setImageWithURLPath(
        URLPath: String,
        placeholderImage: UIImage? = nil,
        progressBlock: ((receivedSize: Int64, totalSize: Int64) -> Void)? = nil,
        completionHandler: ((image: UIImage?, error: NSError?, imageURL: NSURL?) -> Void)?)
    {
        guard let URL = NSURL(string: URLPath) else { return }
        kf_setImageWithURL(URL, placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: progressBlock) { (image, error, cacheType, imageURL) -> () in
            completionHandler?(image: image, error: error, imageURL: imageURL)
        }
    }
}