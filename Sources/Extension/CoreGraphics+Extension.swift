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
public func FlipContextVertically(_ context: CGContext, _ size: CGSize) {
    context.textMatrix = CGAffineTransform.identity
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)
}

/// Flip context by retrieving image
public func FlipImageContextVertically(_ context: CGContext) {
    FlipContextVertically(context, UIGraphicsGetImageFromCurrentImageContext()!.size)
}

/// Query context for size and use screen scale to map from Quartz pixels to UIKit points
public func GetUIKitContextSize() -> CGSize {
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

public extension CGAffineTransform {
    /// X scale from transform
    public var xScale: CGFloat { return sqrt(a * a + c * c) }
    
    /// Y scale from transform
    public var yScale: CGFloat { return sqrt(b * b + d * d) }
    
    /// Rotation in radians
    public var rotation: CGFloat { return CGFloat(atan2f(Float(b), Float(a))) }
}

public extension CGRect {
    public var integral: CGRect { return self.integral }
    public var center: CGPoint { return CGPoint(x: self.midX, y: self.midY) }
    
    /// Return a rect centered a source to a destination
    public func centeringIn(_ destination: CGRect) -> CGRect {
        let dx: CGFloat = destination.midX - self.midX
        let dy: CGFloat = destination.midY - self.midY
        return self.offsetBy(dx: dx, dy: dy)
    }
    
    /// Return a rect fitting a source to a destination
    public func fittingIn(_ destination: CGRect) -> CGRect {
        let aspect = size.aspectScaleToFit(destination)
        let targetSize = size.scale(aspect)
        return CGRectFrom(center: destination.center, size: targetSize)
    }
    
    /// Return a rect that fills the destination
    public func fillingIn(_ destination: CGRect) -> CGRect {
        let aspect = size.aspectScaleToFill(destination)
        let targetSize = size.scale(aspect)
        return CGRectFrom(center: destination.center, size: targetSize)
    }
}

public extension CGSize {
    public var ceilly: CGSize { return CGSize(width: ceil(width), height: ceil(height)) }
    public var floorly: CGSize { return CGSize(width: floor(width), height: floor(height)) }
    
    /// Multiply the size components by the factor
    public func scale(_ factor: CGFloat) -> CGSize {
        return CGSize(width: width * factor, height: height * factor)
    }
    
    /// Calculate scale for fitting a size to a destination rect
    public func aspectScaleToFit(_ fitRect: CGRect) -> CGFloat {
        return min(fitRect.size.width / width, fitRect.size.height / height)
    }
    
    // Calculate scale for filling a destination rect
    public func aspectScaleToFill(_ fillRect: CGRect) -> CGFloat {
        return max(fillRect.size.width / width, fillRect.size.height / height)
    }
}

public extension CGFloat {
    public var ceilly: CGFloat { return ceil(self) }
    public var floorly: CGFloat { return floor(self) }
}

public func CGRectFrom(origin: CGPoint = CGPoint.zero, size: CGSize) -> CGRect {
    return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
}

public func CGRectFrom(center: CGPoint, size: CGSize) -> CGRect {
    let halfWidth = size.width / 2.0
    let halfHeight = size.height / 2.0
    return CGRect(x: center.x - halfWidth,
                      y: center.y - halfHeight,
                      width: size.width,
                      height: size.height
    )
}

/// Return center for rect
public func RectGetCenter(_ rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y + rect.height / 2.0)
}

/// Return calculated bounds
public func PathBoundingBox(_ path: UIBezierPath) -> CGRect {
    return path.cgPath.boundingBoxOfPath
}

/// Return calculated bounds taking line width into account
public func PathBoundingBoxWithLineWidth(_ path: UIBezierPath) -> CGRect {
    let bounds = PathBoundingBox(path)
    return bounds.insetBy(dx: -path.lineWidth / 2.0, dy: -path.lineWidth / 2.0)
}

/// Return the calculated center point
public func PathBoundingCenter(_ path: UIBezierPath) -> CGPoint {
    return RectGetCenter(PathBoundingBox(path))
}

/// Return the center point for the bounds property
public func PathCenter(_ path: UIBezierPath) -> CGPoint {
    return RectGetCenter(path.bounds)
}

/// Translate path’s origin to its center before applying the transform
public func ApplyCenteredPathTransform(_ path: UIBezierPath, _ transform: CGAffineTransform) {
    let center = PathBoundingCenter(path)
    var t = CGAffineTransform.identity
    t = t.translatedBy(x: center.x, y: center.y)
    t = transform.concatenating(t)
    t = t.translatedBy(x: -center.x, y: -center.y)
    path.apply(t)
}

/// Rotate path around its center
public func RotatePath(_ path: UIBezierPath, _ theta: CGFloat) {
    ApplyCenteredPathTransform(path, CGAffineTransform(rotationAngle: theta))
}

/// Scale path to sx, sy
public func ScalePath(_ path: UIBezierPath, _ sx: CGFloat, _ sy:  CGFloat) {
    ApplyCenteredPathTransform(path, CGAffineTransform(scaleX: sx, y: sy))
}

/// Offset a path
public func OffsetPath(_ path: UIBezierPath, _ offset: CGSize) {
    ApplyCenteredPathTransform(path, CGAffineTransform(translationX: offset.width, y: offset.height))
}

/// Make vector for two points
public func PointsMakeVector(_ srcPoint: CGPoint, _ destPoint: CGPoint) -> CGSize {
    return CGSize(width: destPoint.x - srcPoint.x, height: destPoint.y - srcPoint.y)
}

/// Move path to a new origin
public func MovePathToPoint(_ path: UIBezierPath, _ destPoint: CGPoint) {
    let bounds = PathBoundingBox(path)
    let vector = PointsMakeVector(bounds.origin, destPoint)
    OffsetPath(path, vector)
}

/// Center path around a new point
public func MovePathCenterToPoint(_ path: UIBezierPath, _ destPoint: CGPoint) {
    let bounds = PathBoundingBox(path)
    var vector = PointsMakeVector(bounds.origin, destPoint)
    vector.width -= bounds.size.width / 2.0
    vector.height -= bounds.size.height / 2.0
    OffsetPath(path, vector)
}

/// Flip horizontally
public func MirrorPathHorizontally(_ path: UIBezierPath) {
    ApplyCenteredPathTransform(path, CGAffineTransform(scaleX: -1, y: 1))
}

/// Flip vertically
public func MirrorPathVertically(_ path: UIBezierPath) {
    ApplyCenteredPathTransform(path, CGAffineTransform(scaleX: 1, y: -1))
}

public func FitPathToRect(_ path: UIBezierPath, _ destRect: CGRect) {
    let bounds = PathBoundingBox(path)
    let fitRect = bounds.fillingIn(destRect)
    let scale =  bounds.size.aspectScaleToFit(destRect)
    let newCenter = RectGetCenter(fitRect)
    MovePathCenterToPoint(path, newCenter)
    ScalePath(path, scale, scale)
}

public func BezierPathFromString(_ string: NSString, font: UIFont) -> UIBezierPath? {
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
        path.append(UIBezierPath(cgPath: pathRef))
        
        // Offset by size
        let size = (string.substring(with: NSRange( i ..< i + 1)) as NSString).size(attributes: [NSFontAttributeName: font])
        OffsetPath(path, CGSize(width: -size.width, height: 0))
    }
    
    // Clean up
    free(glyphs)
    
    // Return the path to the UIKit coordinate system MirrorPathVertically(path);
    return path
}

public func BezierPolygon(_ numberOfSides: Int) -> UIBezierPath? {
    if numberOfSides < 3 {
        debugPrint("Error: Please supply at least 3 sides")
        return nil
    }
    
    let path = UIBezierPath()
    
    // Use a unit rectangle as the destination
    let destinationRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    let center = RectGetCenter(destinationRect)
    let radius: CGFloat = 0.5
    
    var firstPoint = true
    for i in 0 ..< numberOfSides - 1 {
        let theta: Double = M_PI + Double(i) * 2 * M_PI / Double(numberOfSides)
        let dTheta: Double = 2 * M_PI / Double(numberOfSides)
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
 
