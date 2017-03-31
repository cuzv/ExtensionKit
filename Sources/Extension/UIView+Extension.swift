//
//  UIView+Extension.swift
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

// MARK: - AssociationKey

private struct AssociationKey {
    fileprivate static var gestureRecognizerWrapper: String = "com.mochxiao.uiview.gestureRecognizerWrapper"
    fileprivate static var activityIndicatorView: String = "com.mochxiao.uiview.activityIndicatorView"
    fileprivate static var arcIndicatorLayer: String = "com.mochxiao.uiview.arcIndicatorLayer"
    fileprivate static var isRoundingCornersExists: String = "com.mochxiao.uiview.isRoundingCornersExists"
    
    /// ActionTrampoline
    fileprivate static var singleTapGestureRecognizer: String = "com.mochxiao.uiview.singleTapGestureRecognizer"
    fileprivate static var doubleTapGestureRecognizer: String = "com.mochxiao.uiview.doubleTapGestureRecognizer"
    fileprivate static var longPressGestureRecognizer: String = "com.mochxiao.uiview.longPressGestureRecognizer"
    
    fileprivate static var touchExtendInsets: String = "touchExtendInsets"
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
        
        let tapGesureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGesureRecognizer)
        addGestureRecognizer(tapGesureRecognizer)
        tapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Dobule tap action closure func.
    /// **Note**: You should invoke `longPressAction:` first if you need.
    public func doubleTapsAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        isUserInteractionEnabled = true
        
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        doubleTapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        isUserInteractionEnabled = true
        
        let longPressGesureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
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
                if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer, tapGestureRecognizer.numberOfTapsRequired > 1 {
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
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.singleTapGestureRecognizer)
    }

    /// Dobule taps action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func doubleTapsAction(_ action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true

        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
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
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
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
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = taps
        checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }

    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (Self) -> ()) {
        isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let longPressGesureRecognizer = UILongPressGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
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
} 

// MARK: - Border

public extension UIView {
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
    
    /// Setup border width & color.
    public func setBorder(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separator)
    {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// Add dash border line view using CAShapeLayer.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    /// Because using CAShapeLayer, can not remove it, make sure add only once.
    public func addDashBorderline(
        for rectEdge: UIRectEdge = .all,
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separator,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        lineDashPattern: [CGFloat] = [5, 5])
    {
        func makeLineLayer(
            width: CGFloat,
            color: UIColor,
            lineDashPattern: [CGFloat],
            startPoint: CGPoint,
            endPoint: CGPoint) -> CAShapeLayer
        {
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
        let startX  = 0.5 * w * (1.0 - multiplier) + 0.5 * constant
        let endX    = 0.5 * w * (1.0 + multiplier) - 0.5 * constant
        let startY  = 0.5 * h * (1.0 - multiplier) + 0.5 * constant
        let endY    = 0.5 * h * (1.0 + multiplier) - 0.5 * constant
        
        if rectEdge.contains(.top) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: startX, y: 0),
                endPoint: CGPoint(x: endX, y: 0)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.left) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: 0, y: startY),
                endPoint: CGPoint(x: 0, y: endY)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.bottom) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: startX, y: h),
                endPoint: CGPoint(x: endX, y: h)
            )
            layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.right) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: w, y: startY),
                endPoint: CGPoint(x: w, y: endY)
            )
            layer.addSublayer(lineLayer)
        }
    }

    fileprivate class _BorderLineView: UIView {
        fileprivate var edge: UIRectEdge
        fileprivate init(edge: UIRectEdge) {
            self.edge = edge
            super.init(frame: CGRect.zero)
        }
        
        required fileprivate init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// Add border line view using Autolayout.
    public func addBorderline(
        for rectEdge: UIRectEdge = .all,
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separator,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0)
    {
        func addLineViewConstraints(
            edge: NSLayoutAttribute,
            center: NSLayoutAttribute,
            size: NSLayoutAttribute,
            visualFormat: String,
            color: UIColor,
            multiplier: CGFloat,
            rectEdge: UIRectEdge)
        {
            let lineView = _BorderLineView(edge: rectEdge)
            lineView.backgroundColor = color
            lineView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(lineView)
            
            let edgeConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: edge,
                relatedBy: .equal,
                toItem: self,
                attribute: edge,
                multiplier: 1,
                constant: 0
            )
            let centerConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: center,
                relatedBy: .equal,
                toItem: self,
                attribute: center,
                multiplier: 1,
                constant: 0
            )
            let sizeConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: size,
                relatedBy: .equal,
                toItem: self,
                attribute: size,
                multiplier: multiplier,
                constant: constant
            )
            addConstraints([edgeConstraint, centerConstraint, sizeConstraint])
            
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: visualFormat,
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["lineView": lineView]
            )
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

        if rectEdge.contains(.top) {
            addLineViewConstraints(
                edge: .top,
                center: .centerX,
                size: .width,
                visualFormat: "V:[lineView(\(width))]",
                color: color,
                multiplier: multiplier,
                rectEdge: .top
            )
        }
        
        if rectEdge.contains(.left) {
            addLineViewConstraints(
                edge: .left,
                center: .centerY,
                size: .height,
                visualFormat: "[lineView(\(width))]",
                color: color,
                multiplier: multiplier,
                rectEdge: .left
            )
        }
        
        if rectEdge.contains(.bottom) {
            addLineViewConstraints(
                edge: .bottom,
                center: .centerX,
                size: .width,
                visualFormat: "V:[lineView(\(width))]",
                color: color,
                multiplier: multiplier,
                rectEdge: .bottom
            )
        }
        
        if rectEdge.contains(.right) {
            addLineViewConstraints(
                edge: .right,
                center: .centerY,
                size: .height,
                visualFormat: "[lineView(\(width))]",
                color: color,
                multiplier: multiplier,
                rectEdge: .right
            )
        }
    }
    
    /// Remove added border line view.
    public func removeBorderline(for rectEdge: UIRectEdge = .all) {
        if rectEdge == UIRectEdge() {
            return
        }
        
        for view in subviews {
            if let view = view as? _BorderLineView , rectEdge.contains(view.edge) {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Corner

public extension UIView {
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    public internal(set) var isRoundingCornersExists: Bool {
        get {
            if let value = associatedObject(forKey: &AssociationKey.isRoundingCornersExists) as? Bool {
                return value
            }
            return false
        }
        set { associate(assignObject: newValue, forKey: &AssociationKey.isRoundingCornersExists) }
    }
    
    /// Add rounding corners radius.
    /// **Note**: Before you invoke this method, ensure `self` already have correct frame.
    public func addRoundingCorners(
        for corners: UIRectCorner = .allCorners,
        radius: CGFloat = 3,
        fillColor: UIColor? = nil,
        strokeColor: UIColor? = nil,
        strokeLineWidth: CGFloat = 0)
    {
        if frame.size.equalTo(CGSize.zero) {
            logging("Could not set rounding corners on zero size view.")
            return
        }

        DispatchQueue.global().async {
            let backImage = UIImage.make(
                color: fillColor ?? self.backgroundColor ?? UIColor.white,
                size: self.frame.size,
                roundingCorners: corners,
                radius: radius,
                strokeColor: strokeColor ?? self.backgroundColor ?? UIColor.clear,
                strokeLineWidth: strokeLineWidth
            )
            DispatchQueue.main.async {
                self.backgroundColor = UIColor.clear
                self.layer.contents = backImage?.cgImage
                self.isRoundingCornersExists = true
            }
        }
    }
    
    /// This will remove all added rounding corners on self
    public func removeRoundingCorners() {
        layer.contents = nil
        isRoundingCornersExists = false
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
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "|[blurView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["blurView": blurView]
            ))
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[blurView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["blurView": blurView]
            ))
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
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "|[speclEffectView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["speclEffectView": speclEffectView]
            ))
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[speclEffectView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["speclEffectView": speclEffectView]
            ))
        }
        return speclEffectView
    }
}

// MARK: - UIActivityIndicatorView

public extension UIView {
    fileprivate var activityIndicatorView: UIActivityIndicatorView? {
        get { return associatedObject(forKey: &AssociationKey.activityIndicatorView) as? UIActivityIndicatorView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.activityIndicatorView) }
    }
    
    fileprivate func correspondCenter(dy: CGFloat) -> CGPoint {
        var newCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        newCenter.y += dy
        return newCenter
    }

    /// Add activity indicator animation.
    public func startActivityIndicatorAnimation(indicatorColor color: UIColor = UIColor.lightGray, dy: CGFloat = 0) {
        if isActivityIndicatorAnimating {
            return
        }
        if let activityIndicatorView = self.activityIndicatorView {
            activityIndicatorView.color = color
            activityIndicatorView.center = correspondCenter(dy: dy)
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.color = color
        activityIndicatorView.center = correspondCenter(dy: dy)
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.clipsToBounds = true
        addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        self.activityIndicatorView = activityIndicatorView
    }

    public func stopActivityIndicatorAnimation() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.isHidden = true
    }
    
    public var isActivityIndicatorAnimating: Bool {
        if let activityIndicatorView = activityIndicatorView {
            return activityIndicatorView.isAnimating
        } else {
            return false
        }
    }
}

// MARK: - bgColor

public extension UIView {
    public var bgColor: UIColor? {
        if let bgColor = backgroundColor {
            return bgColor
        }
        if let superview = superview {
            return superview.bgColor
        }
        return nil
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
    
    public func addArcIndicatorLayerAnimation(duration: CFTimeInterval = 3, lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGray) {
        if let arcIndicatorLayer = self.arcIndicatorLayer {
            arcIndicatorLayer.removeAnimation(forKey: stokeAnimationKey)
            arcIndicatorLayer.isHidden = false
            let stokeAnimation = makeStrokeAnimation(duration: duration)
            arcIndicatorLayer.add(stokeAnimation, forKey: stokeAnimationKey)
            return
        }
        
        let arcIndicatorLayer = makeArcIndicatorLayer(lineWidth: lineWidth, lineColor: lineColor)
        let stokeAnimation = makeStrokeAnimation(duration: duration)
        arcIndicatorLayer.add(stokeAnimation, forKey: stokeAnimationKey)
        layer.addSublayer(arcIndicatorLayer)
        self.arcIndicatorLayer = arcIndicatorLayer
    }
    
    public func removeArcIndicatorLayerAnimation() {
        arcIndicatorLayer?.removeAnimation(forKey: stokeAnimationKey)
        arcIndicatorLayer?.isHidden = true
    }
    
    public var isArcIndicatorLayerAnimating: Bool {
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

// MARK: - ExtendTouchRect

public extension UIView {
    public var touchExtendInsets: UIEdgeInsets {
        get {
            if let value = associatedObject(forKey: &AssociationKey.touchExtendInsets) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            return UIEdgeInsets.zero
        }
        set { associate(retainObject: NSValue(uiEdgeInsets: newValue), forKey: &AssociationKey.touchExtendInsets) }
    }
    
    func _ek_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let control = self as? UIControl, !control.isEnabled || isHidden || touchExtendInsets == UIEdgeInsets.zero {
            return _ek_point(inside: point, with: event)
        }
        let extendInsets = UIEdgeInsetsMake(
            -touchExtendInsets.top,
            -touchExtendInsets.left,
            -touchExtendInsets.bottom,
            -touchExtendInsets.right
        )
        var hitFrame = UIEdgeInsetsInsetRect(bounds, extendInsets)
        hitFrame.size.width = max(hitFrame.size.width, 0)
        hitFrame.size.height = max(hitFrame.size.height, 0)
        return hitFrame.contains(point)
    }
}

// MARK: - Layer Image

public extension UIView {
    public var layerImage: UIImage? {
        get {
            if let cg = layer.contents {
                return UIImage(cgImage: cg as! CGImage)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                let imageView = self
                let iw = image.size.width
                let ih = image.size.height
                let vw = bounds.width
                let vh = bounds.height
                let scale = (ih / iw) / (vh / vw)
                if !scale.isNaN && scale > 1 {
                    // 高图只保留顶部
                    imageView.contentMode = .scaleToFill;
                    imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: (iw / ih) * (vh / vw))
                } else {
                    // 宽图把左右两边裁掉
                    imageView.contentMode = .scaleAspectFill
                    imageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                }
                imageView.layer.contents = image.cgImage
            } else {
                layer.contents = nil
            }
        }
    }
}
