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
    private static var gestureRecognizerWrapper: String = "gestureRecognizerWrapper"
    private static var activityIndicatorView: String = "activityIndicatorView"
    private static var arcIndicatorLayer: String = "arcIndicatorLayer"
    private static var executeConainerView: String =  "executeConainerView"
    
    /// ActionTrampoline
    private static var singleTapGestureRecognizer: String = "singleTapGestureRecognizer"
    private static var doubleTapGestureRecognizer: String = "doubleTapGestureRecognizer"
    private static var longPressGestureRecognizer: String = "longPressGestureRecognizer"
}

// MARK: - UIGestureRecognizer

// MARK: The `ClosureDecorator` implement

private extension UIGestureRecognizer {
    private var gestureRecognizerWrapper: ClosureDecorator<(UIView, UIGestureRecognizer)> {
        get { return associatedObjectForKey(&AssociationKey.gestureRecognizerWrapper) as! ClosureDecorator<(UIView, UIGestureRecognizer)> }
        set { associateRetainObject(newValue, forKey: &AssociationKey.gestureRecognizerWrapper) }
    }
}

public extension UIView {
    /// Single tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `doubleTapAction` first if you need.
    public func tapAction(action: ((UIView, UIGestureRecognizer?) -> ())) {
        userInteractionEnabled = true
        
        let tapGesureRecognizer = UITapGestureRecognizer(target: self, action: "handleGestureRecognizerAction:")
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGesureRecognizer)
        addGestureRecognizer(tapGesureRecognizer)
        tapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Dobule tap action closure func.
    /// **Note**: You should invoke `longPressAction:` first if you need.
    public func doubleTapAction(action: (UIView, UIGestureRecognizer?) -> ()) {
        userInteractionEnabled = true
        
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: self, action: "handleGestureRecognizerAction:")
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        doubleTapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Long press action closure func.
    public func longPressAction(action: (UIView, UIGestureRecognizer?) -> ()) {
        userInteractionEnabled = true
        
        let longPressGesureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleGestureRecognizerAction:")
        addGestureRecognizer(longPressGesureRecognizer)
        longPressGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    internal func handleGestureRecognizerAction(sender: UIGestureRecognizer) {
        sender.gestureRecognizerWrapper.invoke((self, sender))
    }
}

private extension UIView {
    private func checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGesureRecognizer: UITapGestureRecognizer) {
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer where tapGestureRecognizer.numberOfTapsRequired > 1 {
                    tapGesureRecognizer.requireGestureRecognizerToFail(gestureRecognizer)
                } else if gestureRecognizer is UILongPressGestureRecognizer {
                    tapGesureRecognizer.requireGestureRecognizerToFail(gestureRecognizer)
                }
            }
        }
    }
    
    private func checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer: UITapGestureRecognizer) {
        if let gesturesRecognizers = gestureRecognizers {
            for gesturesRecognizer in gesturesRecognizers {
                if gesturesRecognizer is UILongPressGestureRecognizer {
                    doubleTapGesureRecognizer.requireGestureRecognizerToFail(gesturesRecognizer)
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
    /// **Note**: You should invoke `longPressAction:` or `doubleTapAction` first if you need.
    public func tapAction(action: ((Self) -> ())) {
        userInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let tapGestureRecognizer = UITapGestureRecognizer(target: trampoline, action: Selector("action:"))
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        associateRetainObject(trampoline, forKey: &AssociationKey.singleTapGestureRecognizer)
    }

    /// Dobule tap action closure func.
    /// **Note**: You should invoke `longPressAction:` first if you need.
    public func doubleTapAction(action: (Self) -> ()) {
        userInteractionEnabled = true

        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(target: trampoline, action: Selector("action:"))
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        associateRetainObject(trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }

    /// Long press action closure func.
    public func longPressAction(action: (Self) -> ()) {
        userInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let longPressGesureRecognizer = UILongPressGestureRecognizer(target: trampoline, action: Selector("action:"))
        addGestureRecognizer(longPressGesureRecognizer)
        associateRetainObject(trampoline, forKey: &AssociationKey.longPressGestureRecognizer)
    }
}

// MARK: - Responder

public extension UIView {
    public var responderViewController: UIViewController? {
        return responderOfClass(UIViewController.self) as? UIViewController
    }
}

// MARK: - Frame & Struct
//@IBDesignable
public extension UIView {
    @IBInspectable public var origin: CGPoint {
        get { return frame.origin }
        set { frame = CGRectMake(newValue.x, newValue.y, width, height) }
    }
    
    @IBInspectable public var size: CGSize {
        get { return frame.size }
        set { frame = CGRectMake(minX, minY, newValue.width, newValue.height) }
    }
    
    @IBInspectable public var minX: CGFloat {
        get { return frame.origin.x }
        set { frame = CGRectMake(newValue, minY, width, height) }
    }
    
    @IBInspectable public var midX: CGFloat {
        get { return CGRectGetMidX(frame) }
        set { frame = CGRectMake(newValue - width / 2, minY, width, height) }
    }
    
    @IBInspectable public var maxX: CGFloat {
        get { return minX + width }
        set { frame = CGRectMake(newValue - width, minY, width, height) }
    }
    
    @IBInspectable public var minY: CGFloat {
        get { return frame.origin.y }
        set { frame = CGRectMake(minX, newValue, width, height) }
    }
    
    @IBInspectable public var midY: CGFloat {
        get { return CGRectGetMidY(frame) }
        set { frame = CGRectMake(minX, newValue - height / 2, width, height) }
    }
    
    @IBInspectable public var maXY: CGFloat {
        get { return minY + height }
        set { frame = CGRectMake(minX, newValue - height, width, height) }
    }
    
    @IBInspectable public var width: CGFloat {
        get { return CGRectGetWidth(bounds) }
        set { frame = CGRectMake(minX, minY, newValue, height) }
    }
    
    @IBInspectable public var height: CGFloat {
        get { return CGRectGetWidth(bounds) }
        set { frame = CGRectMake(minX, minY, width, newValue) }
    }
} 

// MARK: - Corner & Border

@IBDesignable
public extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWith: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let CGColor = layer.borderColor {
                return UIColor(CGColor: CGColor)
            } else {
                return nil
            }
        }
        set { layer.borderColor = newValue?.CGColor }
    }
    
    /// Setup rounding corners radius
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func setRoundingCorners(corners: UIRectCorner, radius: CGFloat) {
        let cornRadiusLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, 0))
        cornRadiusLayer.path = path.CGPath
        layer.mask = cornRadiusLayer
    }
    
    /// Setup border width & color.
    public func setBorder(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor.separatorColor)
    {
        layer.borderWidth = width
        layer.borderColor = color.CGColor
    }
    
    /// Add dash border wiht width & color & lineDashPattern.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addDashBorder(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor.separatorColor,
        lineDashPattern: [CGFloat] = [5, 5])
    {
        let boundLayer = CAShapeLayer()
        boundLayer.lineDashPattern = lineDashPattern
        boundLayer.strokeColor = color.CGColor
        boundLayer.fillColor = UIColor.clearColor().CGColor
        boundLayer.lineJoin = kCALineJoinRound
        boundLayer.lineWidth = width
        let path = UIBezierPath(rect: bounds)
        boundLayer.path = path.CGPath
        layer.addSublayer(boundLayer)
    }
    
    /// Add border line view using Autolayout.
    public func addBorderLine(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor.separatorColor,
        rectEdge: UIRectEdge = .All,
        multiplier: CGFloat = 1)
    {
        func addLineViewConstraint(
            edgeLayoutAttribute edgeLayoutAttribute: NSLayoutAttribute,
            centerLayoutAttribute: NSLayoutAttribute,
            sizeLayoutAttribute: NSLayoutAttribute,
            visualFormat: String,
            color: UIColor,
            multiplier: CGFloat)
        {
            let lineView = UIView()
            lineView.backgroundColor = color
            lineView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(lineView)
            
            let edge = NSLayoutConstraint(item: lineView, attribute: edgeLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: edgeLayoutAttribute, multiplier: 1, constant: 0)
            let center = NSLayoutConstraint(item: lineView, attribute: centerLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: centerLayoutAttribute, multiplier: 1, constant: 0)
            let size = NSLayoutConstraint(item: lineView, attribute: sizeLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: sizeLayoutAttribute, multiplier: multiplier, constant: 0)
            addConstraints([edge, center, size])
            
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["lineView": lineView])
            addConstraints(constraints)
        }
        
        var edgeLayoutAttribute: NSLayoutAttribute = .NotAnAttribute
        var centerLayoutAttribute: NSLayoutAttribute = .NotAnAttribute
        var sizeLayoutAttribute: NSLayoutAttribute = .NotAnAttribute
        
        if rectEdge.contains(.Top) {
            edgeLayoutAttribute = .Top;
            centerLayoutAttribute = .CenterX;
            sizeLayoutAttribute = .Width;
            let visualFormat = "V:[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier)
        }
        
        if rectEdge.contains(.Left) {
            edgeLayoutAttribute = .Left
            centerLayoutAttribute = .CenterY;
            sizeLayoutAttribute = .Height;
            let visualFormat = "[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier)
        }
        
        if rectEdge.contains(.Bottom) {
            edgeLayoutAttribute = .Bottom
            centerLayoutAttribute = .CenterX
            sizeLayoutAttribute = .Width
            let visualFormat = "V:[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier)
        }
        
        if rectEdge.contains(.Right) {
            edgeLayoutAttribute = .Right
            centerLayoutAttribute = .CenterY
            sizeLayoutAttribute = .Height
            let visualFormat = "[lineView(\(width))]"
            addLineViewConstraint(edgeLayoutAttribute: edgeLayoutAttribute, centerLayoutAttribute: centerLayoutAttribute, sizeLayoutAttribute: sizeLayoutAttribute, visualFormat: visualFormat, color: color, multiplier: multiplier)
        }
    }
    
    /// Add border line view using CAShapeLayer.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addDashBorderLine(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor.separatorColor,
        rectEdge: UIRectEdge = .All,
        multiplier: CGFloat = 1,
        lineDashPattern: [CGFloat] = [5, 5])
    {
        func makeLineLayerWithWidth(width: CGFloat, color: UIColor, lineDashPattern: [CGFloat], startPoint: CGPoint, endPoint: CGPoint) -> CAShapeLayer {
            let lineLayer = CAShapeLayer()
            lineLayer.lineDashPattern = lineDashPattern
            lineLayer.strokeColor = color.CGColor
            lineLayer.fillColor = UIColor.clearColor().CGColor
            lineLayer.lineJoin = kCALineJoinRound
            lineLayer.lineWidth = width
            
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y)
            CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
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

        if rectEdge.contains(.Top) {
            let lineLayer = makeLineLayerWithWidth(
                width, color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(startX, 0),
                endPoint: CGPointMake(endX, 0)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.Left) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(0, startY),
                endPoint: CGPointMake(0, endY)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.Bottom) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(startX, h),
                endPoint: CGPointMake(endX, h)
            )
            layer.addSublayer(lineLayer)
        }

        if rectEdge.contains(.Right) {
            let lineLayer = makeLineLayerWithWidth(width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(w, startY),
                endPoint: CGPointMake(w, endY)
            )
            layer.addSublayer(lineLayer)
        }
    }
}

// MARK: - Blur

public extension UIView {
    public func blur() {
        backgroundColor = UIColor.clearColor()
        let backend = UIToolbar(frame: bounds)
        backend.barStyle = .Default
        backend.clipsToBounds = true
        insertSubview(backend, atIndex: 0)
    }
}

// MARK: - UIActivityIndicatorView

public extension UIView {
    public func startActivityIndicatorViewAnimating(onCenter center: CGPoint? = nil, yShift: CGFloat = 0, color: UIColor = UIColor.lightGrayColor()) {

        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.color = color
            activityIndicatorView.center = center ?? correspondingCenterForYShift(yShift)
            activityIndicatorView.startAnimating()
            return
        }
        
        let _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
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
            return activityIndicatorView.isAnimating()
        } else {
            return false
        }
    }
    
    private var activityIndicatorView: UIActivityIndicatorView! {
        get { return associatedObjectForKey(&AssociationKey.activityIndicatorView) as? UIActivityIndicatorView }
        set { associateAssignObject(newValue, forKey: &AssociationKey.activityIndicatorView) }
    }
    
    private func correspondingCenterForYShift(yShift: CGFloat) -> CGPoint {
        var _center = center
        _center.y += yShift
        return _center
    }
}

public extension UIView {
    private var executeConainerView: UIView! {
        get { return associatedObjectForKey(&AssociationKey.executeConainerView) as? UIView }
        set { associateAssignObject(newValue, forKey: &AssociationKey.executeConainerView) }
    }
    
    public func startExecute(backgroundColor backgroundColor: UIColor = UIColor.whiteColor(), indicatorColor: UIColor = UIColor.lightGrayColor()) {
        if let executeConainerView = executeConainerView {
            executeConainerView.backgroundColor = backgroundColor
            executeConainerView.hidden = false
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
        executeConainerView.hidden = true
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
    private var arcIndicatorLayer: CAShapeLayer! {
        get { return associatedObjectForKey(&AssociationKey.arcIndicatorLayer) as? CAShapeLayer }
        set { associateAssignObject(newValue, forKey: &AssociationKey.arcIndicatorLayer) }
    }
    private var stokeAnimationKey: String { return "stokeAnimation" }
    
    private func makeArcIndicatorLayer(lineWidth lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGrayColor()) -> CAShapeLayer {
        let half = min(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        let path = UIBezierPath()
        path.addArcWithCenter(
            CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)),
            radius: half,
            startAngle: CGFloat(-90).radian,
            endAngle: CGFloat(270).radian,
            clockwise: true
        )

        let arcIndicatorLayer = CAShapeLayer()
        arcIndicatorLayer.path = path.CGPath
        arcIndicatorLayer.fillColor = UIColor.clearColor().CGColor
        arcIndicatorLayer.strokeColor = UIColor.lightGrayColor().CGColor
        arcIndicatorLayer.lineWidth = 2;
        arcIndicatorLayer.frame = bounds
        return arcIndicatorLayer
    }
    
    private func makeStrokeAnimation(duration duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = true
        return animation
    }
    
    public func addArcIndicatorLayerAnimated(duration duration: CFTimeInterval = 3, lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGrayColor()) {
        if let arcIndicatorLayer = arcIndicatorLayer {
            arcIndicatorLayer.removeAnimationForKey(stokeAnimationKey)
            arcIndicatorLayer.hidden = false
            let stokeAnimation = makeStrokeAnimation(duration: duration)
            arcIndicatorLayer.addAnimation(stokeAnimation, forKey: stokeAnimationKey)
            return
        }
        
        let _arcIndicatorLayer = makeArcIndicatorLayer(lineWidth: lineWidth, lineColor: lineColor)
        layer.addSublayer(_arcIndicatorLayer)
        arcIndicatorLayer = _arcIndicatorLayer
        
        let stokeAnimation = makeStrokeAnimation(duration: duration)
        _arcIndicatorLayer.addAnimation(stokeAnimation, forKey: stokeAnimationKey)
    }
    
    public func removeArcIndicatorLayer() {
        guard let arcIndicatorLayer = arcIndicatorLayer else { return }
        
        arcIndicatorLayer.removeAnimationForKey(stokeAnimationKey)
        arcIndicatorLayer.hidden = true
    }
    
    public func isArcIndicatorLayerVisible() -> Bool {
        if let arcIndicatorLayer = arcIndicatorLayer {
            return !arcIndicatorLayer.hidden
        } else {
            return false
        }
    }
}

// MARK: - Shake animation

public extension UIView {
    private var shakeAnimationKey: String { return "shakeAnimation" }
    public func shake(horizontal horizontal: Bool = true) {
        layer.removeAnimationForKey(shakeAnimationKey)
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = horizontal ? "position.x" : "position.y"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 1/6.0, 3/6.0, 5/6.0, 1]
        animation.additive = true
        layer.addAnimation(animation, forKey: shakeAnimationKey)
    }
}
