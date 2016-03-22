//
//  UIImage+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/31/15.
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

// MARK: - Generate UIImage

public extension UIImage {
    public class func imageWithColor(color: UIColor, size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public func UIImageFromColor(color: UIColor, size: CGSize = CGSizeMake(1, 1)) -> UIImage {
    return UIImage.imageWithColor(color, size: size)
}

// MARK: - Load image

public extension UIImage {
    /// Load bundle image with file full name
    public class func imageWithFileFullName(fileName: String) -> UIImage? {
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "") {
            return UIImage(contentsOfFile: filePath)
        }
        
        return nil
    }
    
    /// Load bundle image with file name
    public class func imageWithFileName(fileName: String) -> UIImage? {
        let fileFullName = "\(fileName)@\(UIScreen.width > 750 ? 3 : 2)x.png"
        return imageWithFileFullName(fileFullName)
    }
}

public func UIImageFromFileFullName(fileName: String) -> UIImage? {
    return UIImage.imageWithFileFullName(fileName)
}

public func UIImageFromFileName(fileName: String) -> UIImage? {
    return UIImage.imageWithFileName(fileName)
}

// MARK: - Compress & Decompress

public extension UIImage {
    /// Represent current image to render mode original.
    public var originalImage: UIImage {
        return imageWithRenderingMode(.AlwaysOriginal)
    }
    
    /// Decompressed image.
    public var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        drawAtPoint(CGPointZero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage
    }
    
    /// Scale image to target size.
    public func scaleToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Compress image as possible to target size kb.
    public func compressAsPossible(toCapacity capacity: Int = 50, targetSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width)) -> NSData? {
        let currentRepresention = size.width * size.height
        let targetRepresention = targetSize.width * targetSize.height
        var scaledImage = self
        if currentRepresention > targetRepresention {
            scaledImage = scaleToSize(targetSize)
        }
        
        var compressionQuality: CGFloat = 0.5
        let minBytes = capacity * 1024
        var compressedImageData = UIImageJPEGRepresentation(scaledImage, compressionQuality)
        while compressedImageData?.length > minBytes && compressionQuality >= 0.1 {
            compressedImageData = UIImageJPEGRepresentation(scaledImage, compressionQuality)
            compressionQuality -= 0.1
        }
        
        return compressedImageData
    }
    
    public func orientationTo(orientation: UIImageOrientation) -> UIImage {
        if imageOrientation == orientation {
            return self
        }
        
        if let CGImage = CGImage {
            return UIImage(CGImage: CGImage, scale: UIScreen.mainScreen().scale, orientation: orientation)
        }
    
        debugPrint("Cannot complete action.")
        return self
    }
}

// MARK: - Draw

public extension UIImage {
    public func drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output
    }
    
    public func imgeWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        drawInRect(rect, blendMode: .Normal, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

