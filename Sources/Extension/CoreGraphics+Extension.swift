//
//  CoreGraphics+Extension.swift
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

import Foundation
import CoreGraphics
import UIKit

// MARK: -

public extension Double {
    public var radian: CGFloat {
        return CGFloat(self / 180.0 * Double.pi)
    }
    
    public var angle: CGFloat {
        return CGFloat(self / Double.pi * 180.0)
    }
    
    public var pointToPixel: CGFloat {
        return CGFloat(self) * UIScreen.main.scale
    }
    
    public var pixelToPoint: CGFloat {
        return CGFloat(self) / UIScreen.main.scale
    }
}

public extension CGFloat {
    public var radian: CGFloat {
        return CGFloat(Double(native / 180.0) * Double.pi)
    }
    
    public var angle: CGFloat {
        return CGFloat(Double(native) / Double.pi * 180.0)
    }
    
    public var pointToPixel: CGFloat {
        return self * UIScreen.main.scale
    }
    
    public var pixelToPoint: CGFloat {
        return self / UIScreen.main.scale
    }
}

public extension CGFloat {
    public var ceilling: CGFloat { return ceil(self) }
    public var flooring: CGFloat { return floor(self) }
}

public extension CGPoint {
    public var ceilling: CGPoint { return CGPoint(x: ceil(x), y: ceil(y)) }
    public var flooring: CGPoint { return CGPoint(x: floor(x), y: floor(y)) }
    
    public func makeVector(to other: CGPoint) -> CGVector {
        return CGVector(dx: other.x - x, dy: y - other.y)
    }
}

public let CGPointZert = CGPoint.zero

public func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

public func CGPointMake(_ x: Double, _ y: Double) -> CGPoint {
    return CGPoint(x: x, y: y)
}

public func CGPointMake(_ x: Int, _ y: Int) -> CGPoint {
    return CGPoint(x: x, y: y)
}

// MARK: -

public extension CGSize {
    public var ceilling: CGSize { return CGSize(width: ceil(width), height: ceil(height)) }
    public var flooring: CGSize { return CGSize(width: floor(width), height: floor(height)) }
    
    /// Multiply the size components by the factor
    public func scale(factor: CGFloat) -> CGSize {
        return CGSize(width: width * factor, height: height * factor)
    }
    
    /// Calculate scale for fitting a size to a destination size
    public func scale(aspectToFit size: CGSize) -> CGSize {
        return scale(factor: min(size.width / width, size.height / height))
    }
    
    // Calculate scale for filling a destination size
    public func scale(aspectToFill size: CGSize) -> CGSize {
        return scale(factor: max(size.width / width, size.height / height))
    }
}

public let CGSizeZert = CGSize.zero

public func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}

public func CGSizeMake(_ width: Double, _ height: Double) -> CGSize {
    return CGSize(width: width, height: height)
}

public func CGSizeMake(_ width: Int, _ height: Int) -> CGSize {
    return CGSize(width: width, height: height)
}

public func CGSizeEqualToSize(_ lhs: CGSize, _ rhs: CGSize) -> Bool {
    return lhs.equalTo(rhs)
}

// MARK: -

public extension CGVector {
    public var ceilling: CGVector { return CGVector(dx: ceil(dx), dy: ceil(dy)) }
    public var flooring: CGVector { return CGVector(dx: floor(dx), dy: floor(dy)) }
}

public func CGVectorMake(_ dx: CGFloat, dy: CGFloat) -> CGVector {
    return CGVector(dx: dx, dy: dy)
}

public func CGVectorMake(_ dx: Double, dy: Double) -> CGVector {
    return CGVector(dx: dx, dy: dy)
}

public func CGVectorMake(_ dx: Int, dy: Int) -> CGVector {
    return CGVector(dx: dx, dy: dy)
}

// MARK: -

public extension CGRect {
    public var ceilling: CGRect { return CGRectMake(size: size.ceilling) }
    public var flooring: CGRect { return CGRectMake(size: size.flooring) }
    
    /// Return a rect centered a source to a destination
    public func centering(in destination: CGRect) -> CGRect {
        let dx: CGFloat = destination.midX - midX
        let dy: CGFloat = destination.midY - midY
        return offsetBy(dx: dx, dy: dy)
    }
    
    /// Return a rect fitting a source to a destination
    public func fitting(in destination: CGRect) -> CGRect {
        let targetSize = size.scale(aspectToFit: destination.size)
        return CGRectMake(center: destination.center, size: targetSize)
    }
    
    /// Return a rect that fills the destination
    public func filling(in destination: CGRect) -> CGRect {
        let targetSize = size.scale(aspectToFill: destination.size)
        return CGRectMake(center: destination.center, size: targetSize)
    }
    
    public var left: CGFloat {
        set {
            var newOrigin = origin
            newOrigin.x = newValue
            origin = newOrigin
        }
        get { return origin.x }
    }
    
    public var centerX: CGFloat {
        set {
            let diff = newValue - midX
            var newOrigin = origin
            newOrigin.x += diff
            origin = newOrigin
        }
        get { return origin.x + size.width / 2.0 }
    }
    
    public var right: CGFloat {
        set {
            let diff = newValue - maxX
            var newOrigin = origin
            newOrigin.x += diff
            origin = newOrigin
        }
        get { return origin.x + size.width }
    }
    
    public var top: CGFloat {
        set {
            var newOrigin = origin
            newOrigin.y = newValue
            origin = newOrigin
        }
        get { return origin.y }
    }
    
    public var centerY: CGFloat {
        set {
            let diff = newValue - midY
            var newOrigin = origin
            newOrigin.y += diff
            origin = newOrigin
        }
        get { return origin.y + size.height / 2.0 }
    }
    
    public var bottom: CGFloat {
        set {
            let diff = newValue - maxY
            var newOrigin = origin
            newOrigin.y += diff
            origin = newOrigin
        }
        get { return origin.y + size.height }
    }
    
    public var center: CGPoint {
        set {
            var frame = self
            frame.origin.x = newValue.x - frame.size.width * 0.5
            frame.origin.y = newValue.y - frame.size.height * 0.5
            self = frame
        }
        get { return CGPoint(x: origin.x + size.width * 0.5, y: origin.y + size.height * 0.5) }
    }

    public var lengthX: CGFloat {
        set {
            var newSize = size
            newSize.width = newValue
            size = newSize
        }
        get { return size.width }
    }
    
    public var lengthY: CGFloat {
        set {
            var newSize = size
            newSize.height = newValue
            size = newSize
        }
        get { return size.height }
    }
}

public let CGRectZero = CGRect.zero
public let CGRectNull = CGRect.null
public let CGRectInfinite = CGRect.infinite

/// Return center for rect
public func CGRectGetCenter(_ rect: CGRect) -> CGPoint {
    return rect.center
}

public func CGRectMake(origin: CGPoint = CGPoint.zero, size: CGSize) -> CGRect {
    return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
}

public func CGRectMake(center: CGPoint, size: CGSize) -> CGRect {
    let halfWidth = size.width / 2.0
    let halfHeight = size.height / 2.0
    return CGRect(
        x: center.x - halfWidth,
        y: center.y - halfHeight,
        width: size.width,
        height: size.height
    )
}

public func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

public func CGRectMake(_ x: Double, _ y: Double, _ width: Double, _ height: Double) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

public func CGRectMake(_ x: Int, _ y: Int, _ width: Int, _ height: Int) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

public func CGRectGetMinX(_ rect: CGRect) -> CGFloat {
    return rect.minX
}

public func CGRectGetMidX(_ rect: CGRect) -> CGFloat {
    return rect.midX
}

public func CGRectGetMaxX(_ rect: CGRect) -> CGFloat {
    return rect.maxX
}

public func CGRectGetMinY(_ rect: CGRect) -> CGFloat {
    return rect.minY
}

public func CGRectGetMidY(_ rect: CGRect) -> CGFloat {
    return rect.midY
}

public func CGRectGetMaxY(_ rect: CGRect) -> CGFloat {
    return rect.maxY
}

public func CGRectGetWidth(_ rect: CGRect) -> CGFloat {
    return rect.width
}

public func CGRectGetHeight(_ rect: CGRect) -> CGFloat {
    return rect.height
}

public func CGRectEqualToRect(_ lhs: CGRect, _ rhs: CGRect) -> Bool {
    return lhs.equalTo(rhs)
}

public func CGRectStandardize(_ rect: CGRect) -> CGRect {
    return CGRect(x: abs(rect.minX), y: abs(rect.minY), width: abs(rect.width), height: abs(rect.height))
}

public func CGRectIsEmpty(_ rect: CGRect) -> Bool {
    return rect.isEmpty
}

public func CGRectIsNull(_ rect: CGRect) -> Bool {
    return rect.isNull
}

public func CGRectIsInfinite(_ rect: CGRect) -> Bool {
    return rect.isInfinite
}

public func CGRectInset(_ rect: CGRect, _ dx: CGFloat, _ dy: CGFloat) -> CGRect {
    return rect.insetBy(dx: dx, dy: dy)
}

public func CGRectOffset(_ rect: CGRect, _ dx: CGFloat, _ dy: CGFloat) -> CGRect {
    return rect.offsetBy(dx: dx, dy: dy)
}

public func CGRectIntegral(_ rect: CGRect) -> CGRect {
    return rect.integral
}

public func CGRectUnion(_ rect1: CGRect, _ rect2: CGRect) -> CGRect {
    return rect1.union(rect2)
}

public func CGRectIntersection(_ rect1: CGRect, _ rect2: CGRect) -> CGRect {
    return rect2.intersection(rect2)
}

public func CGRectDivide(_ rect: CGRect, _ atDistance: CGFloat, _ from: CGRectEdge) -> (slice: CGRect, remainder: CGRect) {
    return rect.divided(atDistance: atDistance, from: from)
}

public func CGRectContainsPoint(_ rect: CGRect, _ point: CGPoint) -> Bool {
    return rect.contains(point)
}

public func CGRectContainsRect(_ rect1: CGRect, _ rect2: CGRect) -> Bool {
    return rect1.contains(rect2)
}

public func CGRectIntersectsRect(_ rect1: CGRect, _ rect2: CGRect) -> Bool {
    return rect1.intersects(rect2)
}

// MARK: -

public extension CGAffineTransform {
    /// X scale from transform
    public var xScale: CGFloat { return sqrt(a * a + c * c) }
    
    /// Y scale from transform
    public var yScale: CGFloat { return sqrt(b * b + d * d) }
    
    /// Rotation in radians
    public var rotation: CGFloat { return CGFloat(atan2f(Float(b), Float(a))) }
}

// MARK: -

public extension UIBezierPath {
    /// The path bounding box of `path'.
    public var boundingBox: CGRect {
        return cgPath.boundingBoxOfPath
    }
    
    /// The calculated bounds taking line width into account
    public var boundingWithLineBox: CGRect {
        return boundingBox.insetBy(dx: -lineWidth / 2.0, dy: -lineWidth / 2.0)
    }
    
    /// The center point for the path bounding box of `path'.
    public var boundingCenter: CGPoint {
        return CGRectGetCenter(boundingBox)
    }
    
    /// Translate path’s origin to its center before applying the transform
    public func centering(transform: CGAffineTransform) {
        let center = boundingCenter
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: center.x, y: center.y)
        t = transform.concatenating(t)
        t = t.translatedBy(x: -center.x, y: -center.y)
        apply(t)
    }
    
    public func offset(vector: CGVector) {
        centering(transform: CGAffineTransform(translationX: vector.dx, y: vector.dy))
    }
    
    public func rotate(theta: CGFloat) {
        centering(transform: CGAffineTransform(rotationAngle: theta))
    }
    
    /// Move to a new center
    public func moveCenter(to position: CGPoint) {
        let bounds = boundingBox
        var vector = bounds.origin.makeVector(to: position)
        vector.dx -= bounds.size.width / 2.0
        vector.dy -= bounds.size.height / 2.0
        offset(vector: vector)
    }
    
    public func scale(xFactor: CGFloat, yFactor: CGFloat) {
        centering(transform: CGAffineTransform(scaleX: xFactor, y: yFactor))
    }
    
    public func fit(to destRect: CGRect) {
        let bounds = boundingBox
        let fitRect = bounds.filling(in: destRect)
        let factor = min(destRect.size.width / bounds.size.width, destRect.size.height / bounds.size.height)
        moveCenter(to: fitRect.center)
        scale(xFactor: factor, yFactor: factor)
    }
    
    public func horizontalInverst() {
        centering(transform: CGAffineTransform(scaleX: -1, y: 1))
    }
    
    public func verticalInverst() {
        centering(transform: CGAffineTransform(scaleX: 1, y: -1))
    }
    
    public class func make(string: NSString, font: UIFont) -> UIBezierPath? {
        // Initialize path
        let path = UIBezierPath()
        if (0 == string.length) {
            return path
        }
        // Create font ref
        let fontRef = CTFontCreateWithName(font.fontName as CFString?, font.pointSize, nil)
        // Create glyphs (that is, individual letter shapes)
        
        
        var characters = [UniChar]()
        let length = (string as NSString).length
        for i in stride(from: 0, to: length, by: 1) {
            characters.append((string as NSString).character(at: i))
        }
        
        let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: length)
        glyphs.initialize(to: 0)
        
        let success = CTFontGetGlyphsForCharacters(font, characters, glyphs, length)
        if (!success) {
            logging("Error retrieving string glyphs")
            free(glyphs)
            return nil
        }
        
        // Draw each char into path
        for i in 0 ..< string.length {
            // Glyph to CGPath
            let glyph = glyphs[i]
            guard let pathRef = CTFontCreatePathForGlyph(fontRef, glyph, nil) else {
                return nil
            }
            
            // Append CGPath
            path.append(UIBezierPath(cgPath: pathRef))
            
            // Offset by size
            let size = (string.substring(with: NSRange( i ..< i + 1)) as NSString).size(attributes: [NSFontAttributeName: font])
            path.offset(vector: CGVector(dx: -size.width, dy: 0))
        }
        
        // Clean up
        free(glyphs)
        
        // Return the path to the UIKit coordinate system MirrorPathVertically(path);
        return path
    }
    
    public class func makePolygon(numberOfSides: Int) -> UIBezierPath? {
        if numberOfSides < 3 {
            logging("Error: Please supply at least 3 sides")
            return nil
        }
        
        let path = UIBezierPath()
        
        // Use a unit rectangle as the destination
        let destinationRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let center = CGRectGetCenter(destinationRect)
        let radius: CGFloat = 0.5
        
        var firstPoint = true
        for i in 0 ..< numberOfSides - 1 {
            let theta: Double = Double.pi + Double(i) * 2 * Double.pi / Double(numberOfSides)
            let dTheta: Double = 2 * Double.pi / Double(numberOfSides)
            var point = CGPoint.zero
            if firstPoint {
                point.x = center.x + radius * CGFloat(sin(theta))
                point.y = center.y + radius * CGFloat(cos(dTheta))
                firstPoint = false
            }
            point.x = center.x + radius * CGFloat(sin(theta + dTheta))
            point.y = center.y + radius * CGFloat(cos(theta + dTheta))
            
            path.addLine(to: point)
        }
        path.close()
        
        return path
    }
}

/// Query context for size and use screen scale to map from Quartz pixels to UIKit points
public func UIKitGetContextSize() -> CGSize {
    guard let context = UIGraphicsGetCurrentContext() else {
        return CGSize.zero
    }
    
    let size = CGSize(
        width: CGFloat(context.width),
        height: CGFloat(context.height)
    )
    let scale: CGFloat = UIScreen.main.scale
    return CGSize(
        width: size.width / scale,
        height: size.height / scale
    )
}

public extension CGContext {
    /// Horizontal flip context by supplying the size
    public func horizontalInverst(size: CGSize) {
        textMatrix = CGAffineTransform.identity
        translateBy(x: size.width, y: 0)
        scaleBy(x: -1.0, y: 1.0)
    }
    
    /// Vertical flip context by supplying the size
    public func verticalInverst(size: CGSize) {
        textMatrix = CGAffineTransform.identity
        translateBy(x: 0, y: size.height)
        scaleBy(x: 1.0, y: -1.0)
    }

    /// Flip context by retrieving image
    @discardableResult
    public func horizontalInverstImage() -> Bool {
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            horizontalInverst(size: image.size)
            return true
        }
        return false
    }
    
    /// Flip context by retrieving image
    @discardableResult
    public func verticalInverstImage() -> Bool {
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            verticalInverst(size: image.size)
            return true
        }
        return false
    }
}
