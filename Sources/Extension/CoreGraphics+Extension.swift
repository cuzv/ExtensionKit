//
//  CoreGraphics+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 3/14/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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

/// Flip context by supplying the size
public func FlipContextVertically(context: CGContextRef, _ size: CGSize) {
    CGContextSetTextMatrix(context, CGAffineTransformIdentity)
    CGContextTranslateCTM(context, 0, size.height)
    CGContextScaleCTM(context, 1.0, -1.0)
}

/// Flip context by retrieving image
public func FlipImageContextVertically(context: CGContextRef) {
    FlipContextVertically(context, UIGraphicsGetImageFromCurrentImageContext()!.size)
}

/// Query context for size and use screen scale to map from Quartz pixels to UIKit points
public func GetUIKitContextSize() -> CGSize {
    guard let context = UIGraphicsGetCurrentContext() else {
        return CGSizeZero
    }
    
    let size = CGSizeMake(
        CGFloat(CGBitmapContextGetWidth(context)),
        CGFloat(CGBitmapContextGetHeight(context))
    )
    let scale: CGFloat = UIScreen.mainScreen().scale
    return CGSizeMake(
            size.width / scale,
            size.height / scale
    )
}

public extension CGAffineTransform {
    /// X scale from transform
    public var xScale: CGFloat { return sqrt(a * a + c * c) }
    
    /// Y scale from transform
    public var yScale: CGFloat { return sqrt(b * b + d * d) }
    
    /// Rotation in radians
    public var rotation: CGFloat { return CGFloat(atan2f(Float(b), Float(a))) }
}

public extension CGRect {
    public var integral: CGRect { return CGRectIntegral(self) }
    public var center: CGPoint { return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self)) }
    
    /// Return a rect centered a source to a destination
    public func centeringIn(destination: CGRect) -> CGRect {
        let dx: CGFloat = CGRectGetMidX(destination) - CGRectGetMidX(self)
        let dy: CGFloat = CGRectGetMidY(destination) - CGRectGetMidY(self)
        return CGRectOffset(self, dx, dy)
    }
    
    /// Return a rect fitting a source to a destination
    public func fittingIn(destination: CGRect) -> CGRect {
        let aspect = size.aspectScaleToFit(destination)
        let targetSize = size.scale(aspect)
        return CGRectFrom(center: destination.center, size: targetSize)
    }
    
    /// Return a rect that fills the destination
    public func fillingIn(destination: CGRect) -> CGRect {
        let aspect = size.aspectScaleToFill(destination)
        let targetSize = size.scale(aspect)
        return CGRectFrom(center: destination.center, size: targetSize)
    }
}

public extension CGSize {
    public var ceilly: CGSize { return CGSizeMake(ceil(width), ceil(height)) }
    public var floorly: CGSize { return CGSizeMake(floor(width), floor(height)) }
    
    /// Multiply the size components by the factor
    public func scale(factor: CGFloat) -> CGSize {
        return CGSizeMake(width * factor, height * factor)
    }
    
    /// Calculate scale for fitting a size to a destination rect
    public func aspectScaleToFit(fitRect: CGRect) -> CGFloat {
        return min(fitRect.size.width / width, fitRect.size.height / height)
    }
    
    // Calculate scale for filling a destination rect
    public func aspectScaleToFill(fillRect: CGRect) -> CGFloat {
        return max(fillRect.size.width / width, fillRect.size.height / height)
    }
}

public extension CGFloat {
    public var ceilly: CGFloat { return ceil(self) }
    public var floorly: CGFloat { return floor(self) }
}

public func CGRectFrom(origin origin: CGPoint = CGPointZero, size: CGSize) -> CGRect {
    return CGRectMake(origin.x, origin.y, size.width, size.height)
}

public func CGRectFrom(center center: CGPoint, size: CGSize) -> CGRect {
    let halfWidth = size.width / 2.0
    let halfHeight = size.height / 2.0
    return CGRectMake(center.x - halfWidth,
                      center.y - halfHeight,
                      size.width,
                      size.height
    )
}

/// Return center for rect
public func RectGetCenter(rect: CGRect) -> CGPoint {
    return CGPointMake(rect.origin.x + CGRectGetWidth(rect) / 2.0, rect.origin.y + CGRectGetHeight(rect) / 2.0)
}

/// Return calculated bounds
public func PathBoundingBox(path: UIBezierPath) -> CGRect {
    return CGPathGetPathBoundingBox(path.CGPath)
}

/// Return calculated bounds taking line width into account
public func PathBoundingBoxWithLineWidth(path: UIBezierPath) -> CGRect {
    let bounds = PathBoundingBox(path)
    return CGRectInset(bounds, -path.lineWidth / 2.0, -path.lineWidth / 2.0)
}

/// Return the calculated center point
public func PathBoundingCenter(path: UIBezierPath) -> CGPoint {
    return RectGetCenter(PathBoundingBox(path))
}

/// Return the center point for the bounds property
public func PathCenter(path: UIBezierPath) -> CGPoint {
    return RectGetCenter(path.bounds)
}

/// Translate path’s origin to its center before applying the transform
public func ApplyCenteredPathTransform(path: UIBezierPath, _ transform: CGAffineTransform) {
    let center = PathBoundingCenter(path)
    var t = CGAffineTransformIdentity
    t = CGAffineTransformTranslate(t, center.x, center.y)
    t = CGAffineTransformConcat(transform, t)
    t = CGAffineTransformTranslate(t, -center.x, -center.y)
    path.applyTransform(t)
}

/// Rotate path around its center
public func RotatePath(path: UIBezierPath, _ theta: CGFloat) {
    ApplyCenteredPathTransform(path, CGAffineTransformMakeRotation(theta))
}

/// Scale path to sx, sy
public func ScalePath(path: UIBezierPath, _ sx: CGFloat, _ sy:  CGFloat) {
    ApplyCenteredPathTransform(path, CGAffineTransformMakeScale(sx, sy))
}

/// Offset a path
public func OffsetPath(path: UIBezierPath, _ offset: CGSize) {
    ApplyCenteredPathTransform(path, CGAffineTransformMakeTranslation(offset.width, offset.height))
}

/// Make vector for two points
public func PointsMakeVector(srcPoint: CGPoint, _ destPoint: CGPoint) -> CGSize {
    return CGSizeMake(destPoint.x - srcPoint.x, destPoint.y - srcPoint.y)
}

/// Move path to a new origin
public func MovePathToPoint(path: UIBezierPath, _ destPoint: CGPoint) {
    let bounds = PathBoundingBox(path)
    let vector = PointsMakeVector(bounds.origin, destPoint)
    OffsetPath(path, vector)
}

/// Center path around a new point
public func MovePathCenterToPoint(path: UIBezierPath, _ destPoint: CGPoint) {
    let bounds = PathBoundingBox(path)
    var vector = PointsMakeVector(bounds.origin, destPoint)
    vector.width -= bounds.size.width / 2.0
    vector.height -= bounds.size.height / 2.0
    OffsetPath(path, vector)
}

/// Flip horizontally
public func MirrorPathHorizontally(path: UIBezierPath) {
    ApplyCenteredPathTransform(path, CGAffineTransformMakeScale(-1, 1))
}

/// Flip vertically
public func MirrorPathVertically(path: UIBezierPath) {
    ApplyCenteredPathTransform(path, CGAffineTransformMakeScale(1, -1))
}

public func FitPathToRect(path: UIBezierPath, _ destRect: CGRect) {
    let bounds = PathBoundingBox(path)
    let fitRect = bounds.fillingIn(destRect)
    let scale =  bounds.size.aspectScaleToFit(destRect)
    let newCenter = RectGetCenter(fitRect)
    MovePathCenterToPoint(path, newCenter)
    ScalePath(path, scale, scale)
}

public func BezierPathFromString(string: NSString, font: UIFont) -> UIBezierPath? {
    // Initialize path
    let path = UIBezierPath()
    if (0 == string.length) {
        return path
    }
    // Create font ref
    let fontRef = CTFontCreateWithName(font.fontName, font.pointSize, nil)
    // Create glyphs (that is, individual letter shapes) 
    
    
    var characters = [UniChar]()
    let length = (string as NSString).length
    for i in Range(0 ..< length) {
        characters.append((string as NSString).characterAtIndex(i))
    }
    
    let glyphs = UnsafeMutablePointer<CGGlyph>.alloc(length)
    glyphs.initialize(0)
    
    let success = CTFontGetGlyphsForCharacters(font, characters, glyphs, length)
    if (!success) {
        debugPrint("Error retrieving string glyphs")
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
        path.appendPath(UIBezierPath(CGPath: pathRef))
        
        // Offset by size
        let size = (string.substringWithRange(NSRange( i ..< i + 1)) as NSString).sizeWithAttributes([NSFontAttributeName: font])
        OffsetPath(path, CGSizeMake(-size.width, 0))
    }
    
    // Clean up
    free(glyphs)
    
    // Return the path to the UIKit coordinate system MirrorPathVertically(path);
    return path
}

public func BezierPolygon(numberOfSides: Int) -> UIBezierPath? {
    if numberOfSides < 3 {
        debugPrint("Error: Please supply at least 3 sides")
        return nil
    }
    
    let path = UIBezierPath()
    
    // Use a unit rectangle as the destination
    let destinationRect = CGRectMake(0, 0, 1, 1)
    let center = RectGetCenter(destinationRect)
    let radius: CGFloat = 0.5
    
    var firstPoint = true
    for i in 0 ..< numberOfSides - 1 {
        let theta: Double = M_PI + Double(i) * 2 * M_PI / Double(numberOfSides)
        let dTheta: Double = 2 * M_PI / Double(numberOfSides)
        var point = CGPointZero
        if firstPoint {
            point.x = center.x + radius * CGFloat(sin(theta))
            point.y = center.y + radius * CGFloat(cos(dTheta))
            firstPoint = false
        }
        point.x = center.x + radius * CGFloat(sin(theta + dTheta))
        point.y = center.y + radius * CGFloat(cos(theta + dTheta))

        path.addLineToPoint(point)
    }
    path.closePath()
    
    return path
}
 
