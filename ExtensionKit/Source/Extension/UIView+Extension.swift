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
    private static var gestureRecognizerWrapper: String = "closureWrapper"
    private static var activityIndicatorView: String = "activityIndicatorView"
    private static var arcIndicatorLayer: String = "arcIndicatorLayer"
    private static var executeConainerView: String =  "executeConainerView"
}

// MARK: - UIGestureRecognizer

private extension UIGestureRecognizer {
    private var gestureRecognizerWrapper: ClosureWrapper<UIView> {
        get { return associatedObjectForKey(&AssociationKey.gestureRecognizerWrapper) as! ClosureWrapper<UIView> }
        set { associateRetainObject(newValue, forKey: &AssociationKey.gestureRecognizerWrapper) }
    }
}

public extension UIView {
    /// Single tap action closure func.
    /// **Note**: You should call `longPressAction:` or `doubleTapAction` first if you need.
    public func tapAction(action: ((UIView, Any?) -> ())) {
        userInteractionEnabled = true
        
        let tapGesure = UITapGestureRecognizer(target: self, action: "handleTapAction:")
        
        if let gestures = gestureRecognizers {
            for gesture in gestures {
                if let tapGesture = gesture as? UITapGestureRecognizer where tapGesture.numberOfTapsRequired > 1 {
                    tapGesure.requireGestureRecognizerToFail(gesture)
                } else if gesture is UILongPressGestureRecognizer {
                    tapGesure.requireGestureRecognizerToFail(gesture)
                }
            }
        }
        
        addGestureRecognizer(tapGesure)
        tapGesure.gestureRecognizerWrapper = ClosureWrapper(closure: action, holder: self)
    }

    /// Dobule tap action closure func.
    /// **Note**: You should call `longPressAction:` first if you need.
    public func doubleTapAction(action: (UIView, Any?) -> ()) {
        userInteractionEnabled = true
        
        let doubleTapGesure = UITapGestureRecognizer(target: self, action: "handleTapAction:")
        doubleTapGesure.numberOfTapsRequired = 2

        if let gestures = gestureRecognizers {
            for gesture in gestures {
                if gesture is UILongPressGestureRecognizer {
                    doubleTapGesure.requireGestureRecognizerToFail(gesture)
                }
            }
        }

        addGestureRecognizer(doubleTapGesure)
        doubleTapGesure.gestureRecognizerWrapper = ClosureWrapper(closure: action, holder: self)
    }
    
    /// Long press action closure func.
    public func longPressAction(action: (UIView, Any?) -> ()) {
        userInteractionEnabled = true
        
        let longPressGesure = UILongPressGestureRecognizer(target: self, action: "handleTapAction:")
        addGestureRecognizer(longPressGesure)
        longPressGesure.gestureRecognizerWrapper = ClosureWrapper(closure: action, holder: self)
    }
    
    internal func handleTapAction(sender: UITapGestureRecognizer) {
        sender.gestureRecognizerWrapper.invoke()
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
//public extension UIView {
//    @IBInspectable public var origin: CGPoint {
//        get { return self.frame.origin }
//        set { self.frame = CGRectMake(newValue.x, newValue.y, self.width, self.height) }
//    }
//    
//    @IBInspectable public var size: CGSize {
//        get { return self.frame.size }
//        set { self.frame = CGRectMake(self.minX, self.minY, newValue.width, newValue.height) }
//    }
//    
//    @IBInspectable public var minX: CGFloat {
//        get { return self.frame.origin.x }
//        set { self.frame = CGRectMake(newValue, self.minY, self.width, self.height) }
//    }
//    
//    @IBInspectable public var midX: CGFloat {
//        get { return CGRectGetMidX(self.frame) }
//        set { self.frame = CGRectMake(newValue - self.width / 2, self.minY, self.width, self.height) }
//    }
//    
//    @IBInspectable public var maxX: CGFloat {
//        get { return self.minX + self.width }
//        set { self.frame = CGRectMake(newValue - self.width, self.minY, self.width, self.height) }
//    }
//    
//    @IBInspectable public var minY: CGFloat {
//        get { return self.frame.origin.y }
//        set { self.frame = CGRectMake(self.minX, newValue, self.width, self.height) }
//    }
//    
//    @IBInspectable public var midY: CGFloat {
//        get { return CGRectGetMidY(self.frame) }
//        set { self.frame = CGRectMake(self.minX, newValue - self.height / 2, self.width, self.height) }
//    }
//    
//    @IBInspectable public var maXY: CGFloat {
//        get { return self.minY + self.height }
//        set { self.frame = CGRectMake(self.minX, newValue - self.height, self.width, self.height) }
//    }
//    
//    @IBInspectable public var width: CGFloat {
//        get { return CGRectGetWidth(self.bounds) }
//        set { self.frame = CGRectMake(self.minX, self.minY, newValue, self.height) }
//    }
//    
//    @IBInspectable public var height: CGFloat {
//        get { return CGRectGetWidth(self.bounds) }
//        set { self.frame = CGRectMake(self.minX, self.minY, self.width, newValue) }
//    }
//} 

// MARK: - Corner & Border

@IBDesignable
public extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.masksToBounds = newValue > 0
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWith: CGFloat {
        get { return self.layer.borderWidth }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let CGColor = self.layer.borderColor {
                return UIColor(CGColor: CGColor)
            } else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.CGColor
        }
    }
    
    /// Setup rounding corners radius
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func setRoundingCorners(corners: UIRectCorner, radius: CGFloat) {
        let cornRadiusLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, 0))
        cornRadiusLayer.path = path.CGPath
        self.layer.mask = cornRadiusLayer
    }
    
    /// Setup border width & color.
    public func setBorder(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1))
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.CGColor
    }
    
    /// Add dash border wiht width & color & lineDashPattern.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addDashBorder(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1),
        lineDashPattern: [CGFloat] = [5, 5])
    {
        let boundLayer = CAShapeLayer()
        boundLayer.lineDashPattern = lineDashPattern
        boundLayer.strokeColor = color.CGColor
        boundLayer.fillColor = UIColor.clearColor().CGColor
        boundLayer.lineJoin = kCALineJoinRound
        boundLayer.lineWidth = width
        let path = UIBezierPath(rect: self.bounds)
        boundLayer.path = path.CGPath
        self.layer.addSublayer(boundLayer)
    }
    
    /// Add border line view using Autolayout.
    public func addBorderLine(
        width width: CGFloat = 0.5,
        color: UIColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1),
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
            self.addSubview(lineView)
            
            let edge = NSLayoutConstraint(item: lineView, attribute: edgeLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: edgeLayoutAttribute, multiplier: 1, constant: 0)
            let center = NSLayoutConstraint(item: lineView, attribute: centerLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: centerLayoutAttribute, multiplier: 1, constant: 0)
            let size = NSLayoutConstraint(item: lineView, attribute: sizeLayoutAttribute, relatedBy: .Equal, toItem: self, attribute: sizeLayoutAttribute, multiplier: multiplier, constant: 0)
            self.addConstraints([edge, center, size])
            
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["lineView": lineView])
            self.addConstraints(constraints)
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
        color: UIColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1),
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
    
        let w = self.bounds.size.width
        let h = self.bounds.size.height
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
            self.layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.Left) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(0, startY),
                endPoint: CGPointMake(0, endY)
            )
            self.layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.Bottom) {
            let lineLayer = makeLineLayerWithWidth(
                width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(startX, h),
                endPoint: CGPointMake(endX, h)
            )
            self.layer.addSublayer(lineLayer)
        }

        if rectEdge.contains(.Right) {
            let lineLayer = makeLineLayerWithWidth(width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPointMake(w, startY),
                endPoint: CGPointMake(w, endY)
            )
            self.layer.addSublayer(lineLayer)
        }
    }
}

// MARK: - Blur

public extension UIView {
    public func blur() {
        self.backgroundColor = UIColor.clearColor()
        let backend = UIToolbar(frame: self.bounds)
        backend.barStyle = .Default
        backend.clipsToBounds = true
        self.insertSubview(backend, atIndex: 0)
    }
}

// MARK: - UIActivityIndicatorView

public extension UIView {
    private var activityIndicatorView: UIActivityIndicatorView! {
        get { return associatedObjectForKey(&AssociationKey.activityIndicatorView) as? UIActivityIndicatorView }
        set { associateAssignObject(newValue, forKey: &AssociationKey.activityIndicatorView) }
    }
    
    private func correspondingCenterForYShift(yShift: CGFloat) -> CGPoint {
        var center = self.center
        center.y += yShift
        return center
    }
    
    public func startActivityIndicatorViewAnimating(onCenter center: CGPoint? = nil, yShift: CGFloat = 0, color: UIColor = UIColor.lightGrayColor()) {
        if let activityIndicatorView = self.activityIndicatorView {
            activityIndicatorView.color = color
            activityIndicatorView.center = center ?? correspondingCenterForYShift(yShift)
            activityIndicatorView.startAnimating()
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.color = color
        activityIndicatorView.center = center ?? correspondingCenterForYShift(yShift)
        self.addSubview(activityIndicatorView)
        
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }

    public func stopActivityIndicatorViewAnimating() {
        guard let _ = self.activityIndicatorView else { return }
        self.activityIndicatorView.stopAnimating()
    }
    
    public func isActivityIndicatorViewAnimating() -> Bool {
        if let activityIndicatorView = self.activityIndicatorView {
            return activityIndicatorView.isAnimating()
        } else {
            return false
        }
    }
}

public extension UIView {
    private var executeConainerView: UIView! {
        get { return associatedObjectForKey(&AssociationKey.executeConainerView) as? UIView }
        set { associateAssignObject(newValue, forKey: &AssociationKey.executeConainerView) }
    }
    
    public func startExecute(backgroundColor backgroundColor: UIColor = UIColor.whiteColor(), indicatorColor: UIColor = UIColor.lightGrayColor()) {
        if let executeConainerView = self.executeConainerView {
            executeConainerView.backgroundColor = backgroundColor
            executeConainerView.hidden = false
            executeConainerView.startActivityIndicatorViewAnimating(color: indicatorColor)
            return
        }
        
        let executeConainerView = UIView(frame: self.bounds)
        executeConainerView.backgroundColor = backgroundColor
        self.addSubview(executeConainerView)
        self.executeConainerView = executeConainerView
        
        executeConainerView.startActivityIndicatorViewAnimating(color: indicatorColor)
    }

    public func stopExecute() {
        guard let executeConainerView = self.executeConainerView else { return }
        executeConainerView.stopActivityIndicatorViewAnimating()
        executeConainerView.hidden = true
    }
    
    public func isExexuting() -> Bool {
        if let executeConainerView = self.executeConainerView {
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
        let half = min(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let path = UIBezierPath()
        path.addArcWithCenter(
            CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)),
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
        arcIndicatorLayer.frame = self.bounds
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
        if let arcIndicatorLayer = self.arcIndicatorLayer {
            arcIndicatorLayer.removeAnimationForKey(stokeAnimationKey)
            arcIndicatorLayer.hidden = false
            let stokeAnimation = makeStrokeAnimation(duration: duration)
            arcIndicatorLayer.addAnimation(stokeAnimation, forKey: stokeAnimationKey)
            return
        }
        
        let arcIndicatorLayer = makeArcIndicatorLayer(lineWidth: lineWidth, lineColor: lineColor)
        self.layer.addSublayer(arcIndicatorLayer)
        self.arcIndicatorLayer = arcIndicatorLayer
        
        let stokeAnimation = makeStrokeAnimation(duration: duration)
        arcIndicatorLayer.addAnimation(stokeAnimation, forKey: stokeAnimationKey)
    }
    
    public func removeArcIndicatorLayer() {
        guard let arcIndicatorLayer = self.arcIndicatorLayer else { return }
        
        arcIndicatorLayer.removeAnimationForKey(stokeAnimationKey)
        arcIndicatorLayer.hidden = true
    }
    
    public func isArcIndicatorLayerVisible() -> Bool {
        if let arcIndicatorLayer = self.arcIndicatorLayer {
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
        self.layer.removeAnimationForKey(shakeAnimationKey)
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = horizontal ? "position.x" : "position.y"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 1/6.0, 3/6.0, 5/6.0, 1]
        animation.additive = true
        self.layer.addAnimation(animation, forKey: shakeAnimationKey)
    }
}
