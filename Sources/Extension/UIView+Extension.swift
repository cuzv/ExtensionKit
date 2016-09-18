//
//  UIView+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 12/29/15.
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

// MARK: - AssociationKey

private struct AssociationKey {
    fileprivate static var gestureRecognizerWrapper: String = "gestureRecognizerWrapper"
    fileprivate static var activityIndicatorView: String = "activityIndicatorView"
    fileprivate static var arcIndicatorLayer: String = "arcIndicatorLayer"
    fileprivate static var executeConainerView: String =  "executeConainerView"
    
    /// ActionTrampoline
    fileprivate static var singleTapGestureRecognizer: String = "singleTapGestureRecognizer"
    fileprivate static var doubleTapGestureRecognizer: String = "doubleTapGestureRecognizer"
    fileprivate static var longPressGestureRecognizer: String = "longPressGestureRecognizer"
}

// MARK: - UIGestureRecognizer

// MARK: The `ClosureDecorator` implement

private extension UIGestureRecognizer {
    var gestureRecognizerWrapper: ClosureDecorator<(UIView, UIGestureRecognizer)> {
        get { return associatedObject(forKey: &AssociationKey.gestureRecognizerWrapper) as! ClosureDecorator<(UIView, UIGestureRecognizer)> }
        set { associate(retainObject: newValue, forKey: &AssociationKey.gestureRecognizerWrapper) }
    }
}

public extension UIView {
    /// Single tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `doubleTapsAction` first if you need.
    public func tapAction(_ action: @escaping ((UIView, UIGestureRecognizer?) -> ())) {
        isUserInteractionEnabled = true
        
        let tapGesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.handleGestureRecognizerAction(_:)))
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGesureRecognizer)
        addGestureRecognizer(tapGesureRecognizer)
        tapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Dobule tap action closure func.
    /// **Note**: You should invoke `longPressAction:` first if you need.
    public func doubleTapsAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        isUserInteractionEnabled = true
        
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.handleGestureRecognizerAction(_:)))
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        doubleTapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        isUserInteractionEnabled = true
        
        let longPressGesureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UIView.handleGestureRecognizerAction(_:)))
        addGestureRecognizer(longPressGesureRecognizer)
        longPressGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    internal func handleGestureRecognizerAction(_ sender: UIGestureRecognizer) {
        if (sender.state == .ended) {
            sender.gestureRecognizerWrapper.invoke((self, sender))
        }
    }
}

private extension UIView {
    func checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(_ tapGesureRecognizer: UITapGestureRecognizer) {
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer , tapGestureRecognizer.numberOfTapsRequired > 1 {
                    tapGesureRecognizer.require(toFail: gestureRecognizer)
                } else if gestureRecognizer is UILongPressGestureRecognizer {
                    tapGesureRecognizer.require(toFail: gestureRecognizer)
                }
            }
        }
    }
    
    func checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(_ doubleTapGesureRecognizer: UITapGestureRecognizer) {
        if let gesturesRecognizers = gestureRecognizers {
            for gesturesRecognizer in gesturesRecognizers {
                if gesturesRecognizer is UILongPressGestureRecognizer {
                    doubleTapGesureRecognizer.require(toFail: gesturesRecognizer)
                }
            }
        }
    }
}

// MARK: The `ActionTrampoline` implement

@objc public protocol UIGestureRecognizerFunctionProtocol {}
extension UIView: UIGestureRecognizerFunctionProtocol {}

public extension UIGestureRecognizerFunctionProtocol where Self: UIView {
    /// Single tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func tapAction(_ action: @escaping ((Self) -> ())) {
        isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let tapGestureRecognizer = UITapGestureRecognizer(target: trampoline, action: NSSelectorFromString("action:"))
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.singleTapGestureRecognizer)
    }

    /// Dobule taps action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func doubleTapsAction(_ action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true

        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: trampoline, action: NSSelectorFromString("action:"))
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }
    
    /// Triple taps action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func tripleTapsAction(_ action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: trampoline, action: NSSelectorFromString("action:"))
        doubleTapGesureRecognizer.numberOfTapsRequired = 3
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }
    
    /// Multiple tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func multipleTaps(numberOfTapsRequired taps: Int, action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: trampoline, action: NSSelectorFromString("action:"))
        doubleTapGesureRecognizer.numberOfTapsRequired = taps
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }

    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let longPressGesureRecognizer = UILongPressGestureRecognizer(target: trampoline, action: NSSelectorFromString("action:"))
        addGestureRecognizer(longPressGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.longPressGestureRecognizer)
    }
}

// MARK: - Responder

public extension UIView {
    public var responderViewController: UIViewController? {
        return responder(ofClass: UIViewController.self) as? UIViewController
    }
}

// MARK: - Frame & Struct
public extension UIView {
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
        set { frame = CGRect(x: newValue - width / 2, y: minY, width: width, height: height) }
    }
    
    public var centerX: CGFloat {
        get { return frame.midX }
        set { frame = CGRect(x: newValue - width / 2, y: minY, width: width, height: height) }
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
        set { frame = CGRect(x: minX, y: newValue - height / 2, width: width, height: height) }
    }
    
    public var centerY: CGFloat {
        get { return frame.midY }
        set { frame = CGRect(x: minX, y: newValue - height / 2, width: width, height: height) }
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
} 

// MARK: - Corner & Border

public extension UIView {
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    public var borderWith: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    public var borderColor: UIColor? {
        get {
            if let CGColor = layer.borderColor {
                return UIColor(cgColor: CGColor)
            } else {
                return nil
            }
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    /// Setup rounding corners radius
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func setRoundingCorners(
        corners: UIRectCorner = .allCorners,
                radius: CGFloat = 3,
                fillColor: UIColor = UIColor.white,
                strokeColor: UIColor = UIColor.clear,
                strokeLineWidth: CGFloat = 0)
    {
        if frame.size.equalTo(CGSize.zero) {
            debugPrint("Could not set rounding corners on zero size view.")
            return
        }
        if nil != layer.contents {
            return
        }
        
        DispatchQueue.global().async {
            let backImage = UIImageFrom(
                color: fillColor,
                size: self.frame.size,
                roundingCorners: corners,
                radius: radius,
                strokeColor: strokeColor,
                strokeLineWidth: strokeLineWidth
            )
            
            DispatchQueue.main.async {
                self.backgroundColor = UIColor.clear
                self.layer.contents = backImage.cgImage
            }
        }
    }
    
    /// Setup border width & color.
    public func setBorder(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separatorDefaultColor)
    {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// Add dash border wiht width & color & lineDashPattern.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addDashBorder(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separatorDefaultColor,
        lineDashPattern: [CGFloat] = [5, 5])
    {
        let boundLayer = CAShapeLayer()
        boundLayer.lineDashPattern = lineDashPattern as [NSNumber]?
        boundLayer.strokeColor = color.cgColor
        boundLayer.fillColor = UIColor.clear.cgColor
        boundLayer.lineJoin = kCALineJoinRound
        boundLayer.lineWidth = width
        let path = UIBezierPath(rect: bounds)
        boundLayer.path = path.cgPath
        layer.addSublayer(boundLayer)
    }
    
    class _BorderLineView: UIView {
        var edge: UIRectEdge = UIRectEdge()
    }
    
    public func removeBorderLine(rectEdge: UIRectEdge = .all) {
        if rectEdge == UIRectEdge() {
            return
        }
        
        for view in subviews {
            if let view = view as? _BorderLineView , rectEdge.contains(view.edge) {
                view.removeFromSuperview()
            }
        }
    }
    
    /// Add border line view using Autolayout.
    public func addBorderLine(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separatorDefaultColor,
        rectEdge: UIRectEdge = .all,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0)
    {
        func addLineViewConstraint(
            edgeLayoutAttribute: NSLayoutAttribute,
            centerLayoutAttribute: NSLayoutAttribute,
            sizeLayoutAttribute: NSLayoutAttribute,
            visualFormat: String,
            color: UIColor,
            multiplier: CGFloat,
            rectEdge: UIRectEdge)
        {
            let lineView = _BorderLineView()
            lineView.backgroundColor = color
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.edge = rectEdge
            addSubview(lineView)
            
            let edge = NSLayoutConstraint(item: lineView, attribute: edgeLayoutAttribute, relatedBy: .equal, toItem: self, attribute: edgeLayoutAttribute, multiplier: 1, constant: 0)
            let center = NSLayoutConstraint(item: lineView, attribute: centerLayoutAttribute, relatedBy: .equal, toItem: self, attribute: centerLayoutAttribute, multiplier: 1, constant: 0)
            let size = NSLayoutConstraint(item: lineView, attribute: sizeLayoutAttribute, relatedBy: .equal, toItem: self, attribute: sizeLayoutAttribute, multiplier: multiplier, constant: constant)
            addConstraints([edge, center, size])
            
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: NSLayoutFormatOptions(), metrics: nil, views: ["lineView": lineView])
            addConstraints(constraints)
        }
        
        if rectEdge == UIRectEdge() {
            return
        }
        
        for view in subviews {
            if let view = view as? _BorderLineView , rectEdge.contains(view.edge) {
                return
            }
        }
        
        var edgeLayoutAttribute: NSLayoutAttribute = .notAnAttribute
        var centerLayoutAttribute: NSLayoutAttribute = .notAnAttribute
        var sizeLayoutAttribute: NSLayoutAttribute = .notAnAttribute
        
        if rectEdge.contains(.top) {
            edgeLayoutAttribute = .top;
            centerLayoutAttribute = .centerX;
            sizeLayoutAttribute = .width;
            let visualFormat = "V:[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier, rectEdge: .top)
        }
        
        if rectEdge.contains(.left) {
            edgeLayoutAttribute = .left
            centerLayoutAttribute = .centerY;
            sizeLayoutAttribute = .height;
            let visualFormat = "[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier, rectEdge: .left)
        }
        
        if rectEdge.contains(.bottom) {
            edgeLayoutAttribute = .bottom
            centerLayoutAttribute = .centerX
            sizeLayoutAttribute = .width
            let visualFormat = "V:[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier, rectEdge: .bottom)
        }
        
        if rectEdge.contains(.right) {
            edgeLayoutAttribute = .right
            centerLayoutAttribute = .centerY
            sizeLayoutAttribute = .height
            let visualFormat = "[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier, rectEdge: .right)
        }
    }
    
    /// Add border line view using CAShapeLayer.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addDashBorderLine(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separatorDefaultColor,
        rectEdge: UIRectEdge = .all,
        multiplier: CGFloat = 1,
        lineDashPattern: [CGFloat] = [5, 5])
    {
        func makeLineLayerWithWidth(_ width: CGFloat, color: UIColor, lineDashPattern: [CGFloat], startPoint: CGPoint, endPoint: CGPoint) -> CAShapeLayer {
            let lineLayer = CAShapeLayer()
            lineLayer.lineDashPattern = lineDashPattern as [NSNumber]?
            lineLayer.strokeColor = color.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineJoin = kCALineJoinRound
            lineLayer.lineWidth = width
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            path.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            lineLayer.path = path
            
            return lineLayer
        }
    
        let w = bounds.size.width
        let h = bounds.size.height
        let startX = w * (1.0 - multiplier) / 2.0
        // 0.5 * w * (1 + multiplier)
        let endX = 0.5 * w * (1 + multiplier)
        let startY = h * (1.0 - multiplier) / 2.0
        let endY = 0.5 * h * (1 + multiplier)

        if rectEdge.contains(.top) {
            let lineLayer = makeLineLayerWithWidth(
                width, color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: startX, y: 0),
                endPoint: CGPoint(x: endX, y: 0)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.left) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: 0, y: startY),
                endPoint: CGPoint(x: 0, y: endY)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.bottom) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: startX, y: h),
                endPoint: CGPoint(x: endX, y: h)
            )
            layer.addSublayer(lineLayer)
        }

        if rectEdge.contains(.right) {
            let lineLayer = makeLineLayerWithWidth(width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: w, y: startY),
                endPoint: CGPoint(x: w, y: endY)
            )
            layer.addSublayer(lineLayer)
        }
    }
    
    // See: https://github.com/bestswifter/MySampleCode/blob/master/CornerRadius%2FCornerRadius%2FKtCorner.swift
    public func addCorner(
        radius: CGFloat,
        borderWidth: CGFloat = 1.0 / UIScreen.main.scale,
        backgroundColor: UIColor = UIColor.clear,
        borderColor: UIColor = UIColor.black)
    {
        let imageView = UIImageView(image: drawRectWithRoundedCorner(
                radius: radius,
                borderWidth: borderWidth,
                backgroundColor: backgroundColor,
                borderColor: borderColor
            )
        )
        insertSubview(imageView, at: 0)
    }
    
    public func drawRectWithRoundedCorner(
        radius: CGFloat,
        borderWidth: CGFloat,
        backgroundColor: UIColor,
        borderColor: UIColor) -> UIImage?
    {
        
        func ceilbyunit(_ num: Double, _ unit: inout Double) -> Double {
            return num - modf(num, &unit) + unit
        }
        
        func floorbyunit(_ num: Double, _ unit: inout Double) -> Double {
            return num - modf(num, &unit)
        }

        func roundbyunit(_ num: Double, _ unit: inout Double) -> Double {
            let remain = modf(num, &unit)
            if (remain > unit / 2.0) {
                return ceilbyunit(num, &unit)
            } else {
                return floorbyunit(num, &unit)
            }
        }
        
        func pixel(_ num: Double) -> Double {
            var unit: Double
            switch Int(UIScreen.main.scale) {
            case 1: unit = 1.0 / 1.0
            case 2: unit = 1.0 / 2.0
            case 3: unit = 1.0 / 3.0
            default: unit = 0.0
            }
            return roundbyunit(num, &unit)
        }
    
        let sizeToFit = CGSize(width: pixel(Double(bounds.size.width)), height: Double(bounds.size.height))
        let halfBorderWidth = CGFloat(borderWidth / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setLineWidth(borderWidth)
        context.setStrokeColor(borderColor.cgColor)
        context.setFillColor(backgroundColor.cgColor)
        
        let width = sizeToFit.width, height = sizeToFit.height
        context.move(to: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth))  // 开始坐标右边开始
        context.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: width - radius - halfBorderWidth, y: height - halfBorderWidth), radius: radius) // 右下角角度
        context.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: halfBorderWidth, y: height - radius - halfBorderWidth), radius: radius) // 左下角角度
        context.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), radius: radius) // 左上角
        context.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth), radius: radius) // 右上角

        context.drawPath(using: .fillStroke)
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
}

// MARK: - Blur

public extension UIView {
    @available(iOS 8.0, *)
    public class func blurEffect(style: UIBlurEffectStyle = .extraLight) -> UIView {
        let blurView = UIVisualEffectView(frame: CGRect.zero)
        blurView.effect = UIBlurEffect(style: style)
        return blurView
    }
    
    @available(iOS 8.0, *)
    public func addBlurEffectView(style: UIBlurEffectStyle = .extraLight, useAutolayout: Bool = true) -> UIView {
        let blurView = UIView.blurEffect(style: style)
        blurView.frame = bounds
        addSubview(blurView)
        if useAutolayout {
            blurView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[blurView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["blurView": blurView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["blurView": blurView]))
        }
        
        return blurView
    }
    
    @available(iOS 6.0, *)
    public class func speclEffect(style: UIBarStyle = .default) -> UIView {
        let speclEffectView = UIToolbar(frame: CGRect.zero)
        speclEffectView.barStyle = style
        speclEffectView.isTranslucent = true
        return speclEffectView
    }
    
    @available(iOS 6.0, *)
    public func addSpeclEffectView(style: UIBarStyle = .default, useAutolayout: Bool = true) -> UIView {
        let speclEffectView = UIView.speclEffect(style: style)
        speclEffectView.frame = bounds
        if useAutolayout {
            speclEffectView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[speclEffectView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["speclEffectView": speclEffectView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[speclEffectView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["speclEffectView": speclEffectView]))
        }
        return speclEffectView
    }
}

// MARK: - UIActivityIndicatorView

public extension UIView {
    public func startActivityIndicatorViewAnimating(onCenter center: CGPoint? = nil, yShift: CGFloat = 0, color: UIColor = UIColor.lightGray) {
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.color = color
            activityIndicatorView.center = center ?? correspondingCenterForYShift(yShift)
            activityIndicatorView.startAnimating()
            return
        }
        
        let _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        _activityIndicatorView.color = color
        _activityIndicatorView.center = center ?? correspondingCenterForYShift(yShift)
        addSubview(_activityIndicatorView)
        
        activityIndicatorView = _activityIndicatorView
        _activityIndicatorView.startAnimating()
    }

    public func stopActivityIndicatorViewAnimating() {
        guard let _ = activityIndicatorView else { return }
        activityIndicatorView.stopAnimating()
    }
    
    public func isActivityIndicatorViewAnimating() -> Bool {
        if let activityIndicatorView = activityIndicatorView {
            return activityIndicatorView.isAnimating
        } else {
            return false
        }
    }
    
    fileprivate var activityIndicatorView: UIActivityIndicatorView! {
        get { return associatedObject(forKey: &AssociationKey.activityIndicatorView) as? UIActivityIndicatorView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.activityIndicatorView) }
    }
    
    fileprivate func correspondingCenterForYShift(_ yShift: CGFloat) -> CGPoint {
        var _center = center
        _center.y += yShift
        return _center
    }
}

public extension UIView {
    fileprivate var executeConainerView: UIView? {
        get { return associatedObject(forKey: &AssociationKey.executeConainerView) as? UIView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.executeConainerView) }
    }
    
    public func startExecute(backgroundColor: UIColor = UIColor.clear, indicatorColor: UIColor = UIColor.lightGray) {
        if let executeConainerView = executeConainerView {
            executeConainerView.backgroundColor = backgroundColor
            executeConainerView.isHidden = false
            executeConainerView.startActivityIndicatorViewAnimating(color: indicatorColor)
            return
        }
        
        let _executeConainerView = UIView(frame: bounds)
        _executeConainerView.backgroundColor = backgroundColor
        addSubview(_executeConainerView)
        executeConainerView = _executeConainerView
        
        _executeConainerView.startActivityIndicatorViewAnimating(color: indicatorColor)
    }

    public func stopExecute() {
        guard let executeConainerView = executeConainerView else { return }
        executeConainerView.stopActivityIndicatorViewAnimating()
        executeConainerView.isHidden = true
    }
    
    public func isExexuting() -> Bool {
        if let executeConainerView = executeConainerView {
            return executeConainerView.isActivityIndicatorViewAnimating()
        } else {
            return false
        }
    }
}

// MARK: - Arc Animation

public extension UIView {
    fileprivate var arcIndicatorLayer: CAShapeLayer! {
        get { return associatedObject(forKey: &AssociationKey.arcIndicatorLayer) as? CAShapeLayer }
        set { associate(assignObject: newValue, forKey: &AssociationKey.arcIndicatorLayer) }
    }
    fileprivate var stokeAnimationKey: String { return "stokeAnimation" }
    
    fileprivate func makeArcIndicatorLayer(lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGray) -> CAShapeLayer {
        let half = min(bounds.midX, bounds.midY)
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: half,
            startAngle: CGFloat(-90).radian,
            endAngle: CGFloat(270).radian,
            clockwise: true
        )

        let arcIndicatorLayer = CAShapeLayer()
        arcIndicatorLayer.path = path.cgPath
        arcIndicatorLayer.fillColor = UIColor.clear.cgColor
        arcIndicatorLayer.strokeColor = UIColor.lightGray.cgColor
        arcIndicatorLayer.lineWidth = 2;
        arcIndicatorLayer.frame = bounds
        return arcIndicatorLayer
    }
    
    fileprivate func makeStrokeAnimation(duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        return animation
    }
    
    public func addArcIndicatorLayerAnimated(duration: CFTimeInterval = 3, lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGray) {
        if let arcIndicatorLayer = arcIndicatorLayer {
            arcIndicatorLayer.removeAnimation(forKey: stokeAnimationKey)
            arcIndicatorLayer.isHidden = false
            let stokeAnimation = makeStrokeAnimation(duration: duration)
            arcIndicatorLayer.add(stokeAnimation, forKey: stokeAnimationKey)
            return
        }
        
        let _arcIndicatorLayer = makeArcIndicatorLayer(lineWidth: lineWidth, lineColor: lineColor)
        layer.addSublayer(_arcIndicatorLayer)
        arcIndicatorLayer = _arcIndicatorLayer
        
        let stokeAnimation = makeStrokeAnimation(duration: duration)
        _arcIndicatorLayer.add(stokeAnimation, forKey: stokeAnimationKey)
    }
    
    public func removeArcIndicatorLayer() {
        guard let arcIndicatorLayer = arcIndicatorLayer else { return }
        
        arcIndicatorLayer.removeAnimation(forKey: stokeAnimationKey)
        arcIndicatorLayer.isHidden = true
    }
    
    public func isArcIndicatorLayerVisible() -> Bool {
        if let arcIndicatorLayer = arcIndicatorLayer {
            return !arcIndicatorLayer.isHidden
        } else {
            return false
        }
    }
}

// MARK: - Shake animation

public extension UIView {
    fileprivate var shakeAnimationKey: String { return "shakeAnimation" }
    public func shake(horizontal: Bool = true) {
        layer.removeAnimation(forKey: shakeAnimationKey)
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = horizontal ? "position.x" : "position.y"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [
            NSNumber(value: 0),
            NSNumber(value: 1.0 / 6.0),
            NSNumber(value: 3.0 / 6.0),
            NSNumber(value: 5.0 / 6.0),
            NSNumber(value: 1),
        ]
        animation.isAdditive = true
        layer.add(animation, forKey: shakeAnimationKey)
    }
}

// MARK: - Snapshot

public extension UIView {
    public var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        if let content = UIGraphicsGetCurrentContext() {
            layer.render(in: content)
        } else {
            return nil
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       return image
    }
}
