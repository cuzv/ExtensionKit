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
    FlipContextVertically(context, UIGraphicsGetImageFromCurrentImageContext().size)
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