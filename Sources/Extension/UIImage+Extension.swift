//
//  UIImage+Extension.swift
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

// MARK: - Load image

public extension UIImage {
    /// Load bundle image with file name
    public class func load(fileName: String, extensionType: String = "png") -> UIImage? {
        func pathForResource(_ fileName: String, ofType: String) -> String? {
            return Bundle.main.path(forResource: fileName, ofType: ofType)
        }
        
        if UIScreen.main.bounds.width > 375.0 {
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
    
    /// Compress image quality as possible to fit target size.
    public func compressQuality(toByte maxLength: Int) -> Data? {
        let image: UIImage = self
        var compression: CGFloat = 1
        if let data = UIImageJPEGRepresentation(image, compression), data.count < maxLength {
            return data
        }
        
        // Compress by quality
        var max: CGFloat = 1
        var min: CGFloat = 0
        var data: Data!
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)
            if nil != data {
                if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                    min = compression
                } else if data.count > maxLength {
                    max = compression
                } else {
                    break
                }
            }
        }

        return data
    }
    
    /// Compress image quality & size as possible to fit target size.
    func compress(toByte maxLength: Int) -> Data? {
        let image: UIImage = self
        var compression: CGFloat = 1
        if let data = UIImageJPEGRepresentation(image, compression), data.count < maxLength {
            return data
        }
        
        // Compress by quality
        var max: CGFloat = 1
        var min: CGFloat = 0
        var data: Data!
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)
            if nil != data {
                if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                    min = compression
                } else if data.count > maxLength {
                    max = compression
                } else {
                    break
                }
            }
        }
        if data != nil && data.count < maxLength {
            return data
        }
        var resultImage: UIImage! = UIImage(data: data)

        // Compress by size
        var lastDataLength: Int = 0
        while resultImage != nil && data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, compression)!
        }
        return data
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
        
        let roundedRect = CGRect(
            x: strokeLineWidth,
            y: strokeLineWidth,
            width: rect.width - strokeLineWidth * 2,
            height: rect.height - strokeLineWidth * 2)
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
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
        strokeColor: UIColor? = nil,
        strokeLineWidth: CGFloat = 0,
        stockLineJoin: CGLineJoin = .miter) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        
        let roundedRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        let sideLength = min(roundedRect.size.width, roundedRect.size.height)
        if strokeLineWidth < sideLength * 0.5 {
            let roundedpath = UIBezierPath(
                roundedRect: roundedRect.insetBy(dx: strokeLineWidth, dy: strokeLineWidth),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: strokeLineWidth)
            )
            roundedpath.close()
            
            context.saveGState()
            context.addPath(roundedpath.cgPath)
            context.clip()
            context.draw(cgImage!, in: roundedRect)
            context.restoreGState()
        }

        if nil != strokeColor && strokeLineWidth > 0 {
            let strokeInset = (floor(strokeLineWidth * scale) + 0.5) / scale
            let strokeRect = roundedRect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale / 2.0 ? radius - scale / 2.0 : 0.0
            let strokePath = UIBezierPath(
                roundedRect: strokeRect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: strokeRadius, height: strokeLineWidth)
            )
            strokePath.close()

            context.saveGState()
            context.setStrokeColor(strokeColor!.cgColor)
            context.setLineWidth(strokeLineWidth)
            context.setLineJoin(stockLineJoin)
            context.addPath(strokePath.cgPath)
            context.strokePath()
            context.restoreGState()
        }
        
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
    
    public var circle: UIImage {
        var newImage: UIImage = self
        let sideLength = min(size.width, size.height)
        if size.width != size.height {
            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            let newRect = CGRect(x: center.x - sideLength * 0.5, y: center.y - sideLength * 0.5, width: sideLength, height: sideLength)
            if let image = extracting(in: newRect) {
                newImage = image
            }
        }
        return newImage.remake(radius: sideLength * 0.5)
    }
        
    public func remake(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        draw(in: rect, blendMode: .normal, alpha: alpha)
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
    
    public func rendering(color: UIColor, alpha: CGFloat = 1.0) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(rect)
        draw(in: rect, blendMode: .overlay, alpha: alpha)
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
    
    public func builtThumbnail(targetSize: CGSize, useFitting: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }

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
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
    }
    
    /// Extract image
    public func extracting(in subRect: CGRect) -> UIImage? {
        if let imageRef = cgImage!.cropping(to: subRect) {
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
    
    /// Watermarking
    public func watermarking(
        text: String,
        font: UIFont,
        color: UIColor = UIColor.white,
        rotate: Double = Double.pi / 4.0 ) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

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
        (text as NSString).draw(
            in: stringRect,
            withAttributes: [NSForegroundColorAttributeName: color]
        )
        
        // Retrieve the new image
        if let output = UIGraphicsGetImageFromCurrentImageContext() {
            return output
        }
        return self
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
            let detector = CIDetector(
                ofType: CIDetectorTypeQRCode, context: nil,
                options: [CIDetectorAccuracy : CIDetectorAccuracyHigh]
            )
            let features = detector!.features(in: CIImage)
            if let first = features.first as? CIQRCodeFeature {
                return first.messageString!.length > 0
            }
        }
        return false
    }
}
