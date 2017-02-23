//
//  CALayer+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 2/22/17.
//  Copyright © 2017 Moch. All rights reserved.
//

import Foundation
import QuartzCore

// MARK: - Frame & Struct
public extension CALayer {
    public var origin: CGPoint {
        get { return frame.origin }
        set { frame = CGRect(x: newValue.x, y: newValue.y, width: width, height: height) }
    }
    
    public var size: CGSize {
        get { return frame.size }
        set { frame = CGRect(x: minX, y: minY, width: newValue.width, height: newValue.height) }
    }
    
    public var minX: CGFloat {
        get { return frame.origin.x }
        set { frame = CGRect(x: newValue, y: minY, width: width, height: height) }
    }
    
    public var left: CGFloat {
        get { return frame.origin.x }
        set { frame = CGRect(x: newValue, y: minY, width: width, height: height) }
    }
    
    public var midX: CGFloat {
        get { return frame.midX }
        set { frame = CGRect(x: newValue - width * 0.5, y: minY, width: width, height: height) }
    }
    
    public var centerX: CGFloat {
        get { return frame.midX }
        set { frame = CGRect(x: newValue - width * 0.5, y: minY, width: width, height: height) }
    }
    
    public var maxX: CGFloat {
        get { return minX + width }
        set { frame = CGRect(x: newValue - width, y: minY, width: width, height: height) }
    }
    
    public var right: CGFloat {
        get { return minX + width }
        set { frame = CGRect(x: newValue - width, y: minY, width: width, height: height) }
    }
    
    public var minY: CGFloat {
        get { return frame.origin.y }
        set { frame = CGRect(x: minX, y: newValue, width: width, height: height) }
    }
    
    public var top: CGFloat {
        get { return frame.origin.y }
        set { frame = CGRect(x: minX, y: newValue, width: width, height: height) }
    }
    
    public var midY: CGFloat {
        get { return frame.midY }
        set { frame = CGRect(x: minX, y: newValue - height * 0.5, width: width, height: height) }
    }
    
    public var centerY: CGFloat {
        get { return frame.midY }
        set { frame = CGRect(x: minX, y: newValue - height * 0.5, width: width, height: height) }
    }
    
    public var maxY: CGFloat {
        get { return minY + height }
        set { frame = CGRect(x: minX, y: newValue - height, width: width, height: height) }
    }
    
    public var bottom: CGFloat {
        get { return minY + height }
        set { frame = CGRect(x: minX, y: newValue - height, width: width, height: height) }
    }
    
    public var width: CGFloat {
        get { return bounds.width }
        set { frame = CGRect(x: minX, y: minY, width: newValue, height: height) }
    }
    
    public var height: CGFloat {
        get { return bounds.height }
        set { frame = CGRect(x: minX, y: minY, width: width, height: newValue) }
    }
    
    public var center: CGPoint {
        set { frame = CGRect(x: newValue.x - frame.size.width * 0.5, y: newValue.y - frame.size.height * 0.5, width: width, height: height) }
        get { return CGPoint(x: origin.x + size.width * 0.5, y: origin.y + size.height * 0.5) }
    }
}

public extension CALayer {
    public var snapshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func setShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = 1
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    public func removeAllSublayers() {
        sublayers?.forEach { (sender) in
            sender.removeFromSuperlayer()
        }
    }
}



