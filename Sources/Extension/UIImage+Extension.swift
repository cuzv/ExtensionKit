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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// MARK: - Load image

public extension UIImage {
    /// Load bundle image with file name
    public class func imageWithFileName(_ fileName: String, ofType: String = "png") -> UIImage? {
        func pathForResource(_ fileName: String, ofType: String) -> String? {
            return Bundle.main.path(forResource: fileName, ofType: ofType)
        }
        
        if UIScreen.width > 375 {
            if let filePath = pathForResource("\(fileName)@3x", ofType: ofType) {
                return UIImage(contentsOfFile: filePath)
            }
        }
        
        if let filePath = pathForResource("\(fileName)@2x", ofType: ofType) {
            return UIImage(contentsOfFile: filePath)
        }
        
        if let filePath = pathForResource(fileName, ofType: ofType) {
            return UIImage(contentsOfFile: filePath)
        }
        
        return nil
    }
}

public func UIImageFromFileName(_ fileName: String, ofType: String = "png") -> UIImage? {
    return UIImage.imageWithFileName(fileName, ofType: ofType)
}

// MARK: - Compress & Decompress

public extension UIImage {
    /// Represent current image to render mode original.
    public var originalImage: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// Decompressed image.
    public var decompressed: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage!
    }
        
    /// Compress image as possible to target size kb.
    public func compressAsPossible(toCapacity capacity: Int = 50, targetSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)) -> Data? {
        let currentRepresention = size.width * size.height
        let targetRepresention = targetSize.width * targetSize.height
        var scaledImage = self
        if currentRepresention > targetRepresention {
            scaledImage = buildThumbnail(targetSize: targetSize)
        }
        
        var compressionQuality: CGFloat = 0.5
        let minBytes = capacity * 1024
        var compressedImageData = UIImageJPEGRepresentation(scaledImage, compressionQuality)
        while compressedImageData?.count > minBytes && compressionQuality >= 0.1 {
            compressedImageData = UIImageJPEGRepresentation(scaledImage, compressionQuality)
            compressionQuality -= 0.1
        }
        
        return compressedImageData
    }
    
    public func orientationTo(_ orientation: UIImageOrientation) -> UIImage {
        if imageOrientation == orientation {
            return self
        }
        
        if let CGImage = cgImage {
            return UIImage(cgImage: CGImage, scale: UIScreen.main.scale, orientation: orientation)
        }
    
        debugPrint("Cannot complete action.")
        return self
    }
    
    public var bytes: Data? {
        // Establish color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Establish context
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            ) else { return nil }
        
        // Draw source into context bytes
        let rect = CGRectFrom(size: size)
        guard let CGImage = cgImage else {
            return nil
        }
        context.draw(CGImage, in: rect)
        
        // Create NSData from bytes
        if let data = context.data {
            return Data(bytes: UnsafeMutableRawPointer(data), count: (width * height * 4))
        } else {
            return nil
        }
    }
}

// MARK: - Draw

public extension UIImage {
    public class func imageWith(
        color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1),
        roundingCorners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor = UIColor.clear,
        strokeLineWidth: CGFloat = 0) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        
        context.setFillColor(color.cgColor)
        context.setLineWidth(strokeLineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        
        let roundedRect = CGRect(x: strokeLineWidth, y: strokeLineWidth, width: rect.width - strokeLineWidth * 2, height: rect.height - strokeLineWidth * 2)
        let path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        context.addPath(path.cgPath)
        
        context.drawPath(using: .fillStroke)
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
    public func imageWith(
        roundingCorners corners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor = UIColor.clear,
        strokeLineWidth: CGFloat = 1.0 / UIScreen.main.scale
    ) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        context.addPath(path.cgPath)
        
        context.clip()
        draw(in: rect)
        
        context.setLineWidth(strokeLineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        let roundedRect = CGRect(x: strokeLineWidth, y: strokeLineWidth, width: rect.width - strokeLineWidth * 2, height: rect.height - strokeLineWidth * 2)
        let roundedPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        roundedPath.stroke()
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output!
    }

    public func imgeWithAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect, blendMode: .normal, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func rendering(color: UIColor, alpha: CGFloat = 1.0) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(rect)
        draw(in: rect, blendMode: .overlay, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func buildThumbnail(targetSize: CGSize, useFitting: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        // Establish the output thumbnail rectangle
        let targetRect = CGRectFrom(origin: CGPoint.zero, size: targetSize)
        // Create the source image’s bounding rectangle
        let naturalRect = CGRectFrom(origin: CGPoint.zero, size: size)
        // Calculate fitting or filling destination rectangle 
        // See Chapter 2 for a discussion on these functions 
        let destinationRect = useFitting ? naturalRect.fittingIn(targetRect) : naturalRect.fillingIn(targetRect)
        // Draw the new thumbnail
        draw(in: destinationRect)
        // Retrieve and return the new image 
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbnail!
    }
    
    /// Extract image
    public func extractingIn(_ subRect: CGRect) -> UIImage? {
        if let imageRef = cgImage!.cropping(to: subRect) {
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
   
    /// Watermarking
    public func watermarking(text: String, font: UIFont, color: UIColor = UIColor.white, rotate: Double = M_PI_4 ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the original image into the context
        let targetRect = CGRectFrom(size: size)
        draw(in: targetRect)
        
        // Rotate the context
        let center = targetRect.center
        context!.translateBy(x: center.x, y: center.y)
        context!.rotate(by: CGFloat(rotate))
        context!.translateBy(x: -center.x, y: -center.y)
        
        let stringSize = text.sizeFrom(font: font, preferredMaxLayoutWidth: size.width)
        let stringRect = CGRectFrom(size: stringSize).centeringIn(CGRectFrom(size: size))
        
        // Draw the string, using a blend mode
        context!.setBlendMode(.normal)
        (text as NSString).draw(in: stringRect, withAttributes: [NSForegroundColorAttributeName: color])
        
        // Retrieve the new image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

public func UIImageFrom(
    color: UIColor,
    size: CGSize = CGSize(width: 1, height: 1),
    roundingCorners: UIRectCorner = .allCorners,
    radius: CGFloat = 0,
    strokeColor: UIColor = UIColor.clear,
    strokeLineWidth: CGFloat = 0) -> UIImage
{
    return UIImage.imageWith(color: color, size: size, roundingCorners: roundingCorners, radius: radius, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
}

@available(iOS 8.0, *)
public func UIImageIsQRCode(_ image: UIImage) -> Bool {
    if let CIImage = CIImage(image: image) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil,
                                  options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector!.features(in: CIImage)
        if let first = features.first as? CIQRCodeFeature {
            return first.messageString!.length > 0
        }
    }

    return false
}
