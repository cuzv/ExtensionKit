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
    public class func load(fileName: String, extensionType: String = "png") -> UIImage? {
        func pathForResource(_ fileName: String, ofType: String) -> String? {
            return Bundle.main.path(forResource: fileName, ofType: ofType)
        }
        
        if UIScreen.width > 375 {
            if let filePath = pathForResource("\(fileName)@3x", ofType: extensionType) {
                return UIImage(contentsOfFile: filePath)
            }
        }
        
        if let filePath = pathForResource("\(fileName)@2x", ofType: extensionType) {
            return UIImage(contentsOfFile: filePath)
        }
        
        if let filePath = pathForResource(fileName, ofType: extensionType) {
            return UIImage(contentsOfFile: filePath)
        }
        
        return nil
    }
}

// MARK: - Compress & Decompress

public extension UIImage {
    /// Represent current image to render mode original.
    public var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// Decompressed image.
    public var decompressed: UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        guard let decompressedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return decompressedImage
    }
    
    /// Compress image as possible to target size kb.
    public func compressingAsPossible(capacity: Int = 50, targetSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)) -> Data? {
        let currentRepresention = size.width * size.height
        let targetRepresention = targetSize.width * targetSize.height
        var scaledImage = self
        if currentRepresention > targetRepresention {
            scaledImage = builtThumbnail(targetSize: targetSize) ?? self
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
    
    public func orientation(to orientation: UIImageOrientation) -> UIImage {
        if imageOrientation == orientation {
            return self
        }
        
        if let CGImage = cgImage {
            return UIImage(cgImage: CGImage, scale: UIScreen.main.scale, orientation: orientation)
        }
        logging("Cannot complete action.")
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
        let rect = CGRectMake(size: size)
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
    
    public func color(atPixel point: CGPoint) -> UIColor? {
        let width = size.width
        let height = size.height
        if !CGRect(x: 0, y: 0, width: width, height: height).contains(point) {
            return nil
        }
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * 1
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        var pixelData: [CGFloat] = [0, 0, 0, 0]
        
        guard let context = CGContext(
            data: &pixelData,
            width: 1,
            height: 1,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        let pointX = trunc(point.x)
        let pointY = trunc(point.y)
        guard let cgImage = cgImage else { return nil }
        context.translateBy(x: -pointX, y: pointY - height)
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return UIColor(red: pixelData[0] / 255.0, green: pixelData[1] / 255.0, blue: pixelData[2] / 255.0, alpha: pixelData[3] / 255.0)
    }
}

// MARK: - Draw

public extension UIImage {
    public class func make(
        color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1),
        roundingCorners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor = UIColor.clear,
        strokeLineWidth: CGFloat = 0) -> UIImage?
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
        
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
    
    public func remake(
        roundingCorners corners: UIRectCorner = .allCorners,
        radius: CGFloat = 0,
        strokeColor: UIColor = UIColor.clear,
        strokeLineWidth: CGFloat = 1.0 / UIScreen.main.scale) -> UIImage?
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
        
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
    
    public func remake(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect, blendMode: .normal, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func rendering(color: UIColor, alpha: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(rect)
        draw(in: rect, blendMode: .overlay, alpha: alpha)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
    
    public func builtThumbnail(targetSize: CGSize, useFitting: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        // Establish the output thumbnail rectangle
        let targetRect = CGRectMake(origin: CGPoint.zero, size: targetSize)
        // Create the source image’s bounding rectangle
        let naturalRect = CGRectMake(origin: CGPoint.zero, size: size)
        // Calculate fitting or filling destination rectangle
        // See Chapter 2 for a discussion on these functions
        let destinationRect = useFitting ? naturalRect.fitting(in: targetRect) : naturalRect.filling(in: targetRect)
        // Draw the new thumbnail
        draw(in: destinationRect)
        // Retrieve and return the new image
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
    
    /// Extract image
    public func extracting(in subRect: CGRect) -> UIImage? {
        if let imageRef = cgImage!.cropping(to: subRect) {
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
    
    /// Watermarking
    public func watermarking(text: String, font: UIFont, color: UIColor = UIColor.white, rotate: Double = M_PI_4 ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the original image into the context
        let targetRect = CGRectMake(size: size)
        draw(in: targetRect)
        
        // Rotate the context
        let center = targetRect.center
        context!.translateBy(x: center.x, y: center.y)
        context!.rotate(by: CGFloat(rotate))
        context!.translateBy(x: -center.x, y: -center.y)
        
        let stringSize = text.layoutSize(font: font, preferredMaxLayoutWidth: size.width)
        let stringRect = CGRectMake(size: stringSize).centering(in: CGRectMake(size: size))
        
        // Draw the string, using a blend mode
        context!.setBlendMode(.normal)
        (text as NSString).draw(in: stringRect, withAttributes: [NSForegroundColorAttributeName: color])
        
        // Retrieve the new image
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }
}

public func UIImageFrom(
    color: UIColor,
    size: CGSize = CGSize(width: 1, height: 1),
    roundingCorners: UIRectCorner = .allCorners,
    radius: CGFloat = 0,
    strokeColor: UIColor = UIColor.clear,
    strokeLineWidth: CGFloat = 0) -> UIImage?
{
    return UIImage.make(
        color: color,
        size: size,
        roundingCorners: roundingCorners,
        radius: radius,
        strokeColor: strokeColor,
        strokeLineWidth: strokeLineWidth
    )
}

public extension UIImage {
    @available(iOS 8.0, *)
    public var isQRCode: Bool {
        if let CIImage = CIImage(image: self) {
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil,
                                      options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
            let features = detector!.features(in: CIImage)
            if let first = features.first as? CIQRCodeFeature {
                return first.messageString!.length > 0
            }
        }
        return false
    }
}
