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

// MARK: - Swizzle

extension UIView {
    override open class func initialize() {
        if self != UIButton.self {
            return
        }
        swizzleInstanceMethod(
            for: UIView.self,
            original: #selector(UIView.point(inside:with:)),
            override: #selector(UIView._ek_point(inside:with:))
        )
    }
}

// MARK: - UIGestureRecognizer

// MARK: The `ClosureDecorator` implement

private extension UIGestureRecognizer {
    var gestureRecognizerWrapper: ClosureDecorator<(UIView, UIGestureRecognizer)> {
        get { return ext.associatedObject(forKey: &AssociationKey.gestureRecognizerWrapper) as! ClosureDecorator<(UIView, UIGestureRecognizer)> }
        set { ext.associate(retainObject: newValue, forKey: &AssociationKey.gestureRecognizerWrapper) }
    }
}

public extension Extension where Base: UIView {
    /// Single tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `doubleTapsAction` first if you need.
    public func tapAction(_ action: @escaping ((UIView, UIGestureRecognizer?) -> ())) {
        base.isUserInteractionEnabled = true
        
        let tapGesureRecognizer = UITapGestureRecognizer(
            target: base,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
        base.checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGesureRecognizer)
        base.addGestureRecognizer(tapGesureRecognizer)
        tapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Dobule tap action closure func.
    /// **Note**: You should invoke `longPressAction:` first if you need.
    public func doubleTapsAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        base.isUserInteractionEnabled = true
        
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: base,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        base.checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        base.addGestureRecognizer(doubleTapGesureRecognizer)
        doubleTapGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (UIView, UIGestureRecognizer?) -> ()) {
        base.isUserInteractionEnabled = true
        
        let longPressGesureRecognizer = UILongPressGestureRecognizer(
            target: base,
            action: #selector(UIView.handleGestureRecognizerAction(_:))
        )
        base.addGestureRecognizer(longPressGesureRecognizer)
        longPressGesureRecognizer.gestureRecognizerWrapper = ClosureDecorator(action)
    }
    
}

private extension UIView {
    dynamic func handleGestureRecognizerAction(_ sender: UIGestureRecognizer) {
        if (sender.state == .ended) {
            sender.gestureRecognizerWrapper.invoke((self, sender))
        }
    }

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

public extension Extension where Base: UIView {
    /// Single tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func tapAction(_ action: @escaping ((UIView) -> ())) {
        base.isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        base.checkRequireGestureRecognizerToFailForSingleTapGesureRecognizer(tapGestureRecognizer)
        base.addGestureRecognizer(tapGestureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.singleTapGestureRecognizer)
    }

    /// Dobule taps action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func doubleTapsAction(_ action: @escaping (UIView) -> ()) {
        base.isUserInteractionEnabled = true

        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = 2
        base.checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        base.addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }
    
    /// Triple taps action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func tripleTapsAction(_ action: @escaping (UIView) -> ()) {
        base.isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = 3
        base.checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        base.addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }
    
    /// Multiple tap action closure func.
    /// **Note**: You should invoke `longPressAction:` or `tripleTapsAction` first if you need.
    public func multipleTaps(numberOfTapsRequired taps: Int, action: @escaping (UIView) -> ()) {
        base.isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let doubleTapGesureRecognizer = UITapGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        doubleTapGesureRecognizer.numberOfTapsRequired = taps
        base.checkRequireGestureRecognizerToFailForDoubleTapGesureRecognizer(doubleTapGesureRecognizer)
        base.addGestureRecognizer(doubleTapGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.doubleTapGestureRecognizer)
    }

    /// Long press action closure func.
    public func longPressAction(_ action: @escaping (UIView) -> ()) {
        base.isUserInteractionEnabled = true
        
        let trampoline = ActionTrampoline(action: action)
        let longPressGesureRecognizer = UILongPressGestureRecognizer(
            target: trampoline,
            action: trampoline.selector
        )
        base.addGestureRecognizer(longPressGesureRecognizer)
        associate(retainObject: trampoline, forKey: &AssociationKey.longPressGestureRecognizer)
    }
}

// MARK: - Responder

public extension Extension where Base: UIView {
    public var responderViewController: UIViewController? {
        return responder(ofClass: UIViewController.self) as? UIViewController
    }
}

// MARK: - Frame & Struct
public extension Extension where Base: UIView {
    public var origin: CGPoint {
        get { return base.frame.origin }
        set { base.frame = CGRect(x: newValue.x, y: newValue.y, width: width, height: height) }
    }
    
    public var size: CGSize {
        get { return base.frame.size }
        set { base.frame = CGRect(x: minX, y: minY, width: newValue.width, height: newValue.height) }
    }
    
    public var minX: CGFloat {
        get { return base.frame.origin.x }
        set { base.frame = CGRect(x: newValue, y: minY, width: width, height: height) }
    }
    
    public var left: CGFloat {
        get { return base.frame.origin.x }
        set { base.frame = CGRect(x: newValue, y: minY, width: width, height: height) }
    }
    
    public var midX: CGFloat {
        get { return base.frame.midX }
        set { base.frame = CGRect(x: newValue - width / 2.0, y: minY, width: width, height: height) }
    }
    
    public var centerX: CGFloat {
        get { return base.frame.midX }
        set { base.frame = CGRect(x: newValue - width / 2.0, y: minY, width: width, height: height) }
    }
    
    public var maxX: CGFloat {
        get { return minX + width }
        set { base.frame = CGRect(x: newValue - width, y: minY, width: width, height: height) }
    }
    
    public var right: CGFloat {
        get { return minX + width }
        set { base.frame = CGRect(x: newValue - width, y: minY, width: width, height: height) }
    }
    
    public var minY: CGFloat {
        get { return base.frame.origin.y }
        set { base.frame = CGRect(x: minX, y: newValue, width: width, height: height) }
    }
    
    public var top: CGFloat {
        get { return base.frame.origin.y }
        set { base.frame = CGRect(x: minX, y: newValue, width: width, height: height) }
    }
    
    public var midY: CGFloat {
        get { return base.frame.midY }
        set { base.frame = CGRect(x: minX, y: newValue - height / 2.0, width: width, height: height) }
    }
    
    public var centerY: CGFloat {
        get { return base.frame.midY }
        set { base.frame = CGRect(x: minX, y: newValue - height / 2.0, width: width, height: height) }
    }
    
    public var maxY: CGFloat {
        get { return minY + height }
        set { base.frame = CGRect(x: minX, y: newValue - height, width: width, height: height) }
    }
    
    public var bottom: CGFloat {
        get { return minY + height }
        set { base.frame = CGRect(x: minX, y: newValue - height, width: width, height: height) }
    }
    
    public var width: CGFloat {
        get { return base.bounds.width }
        set { base.frame = CGRect(x: minX, y: minY, width: newValue, height: height) }
    }
    
    public var height: CGFloat {
        get { return base.bounds.height }
        set { base.frame = CGRect(x: minX, y: minY, width: width, height: newValue) }
    }
} 

// MARK: - Border

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

public extension Extension where Base: UIView {
    public var borderWith: CGFloat {
        get { return base.layer.borderWidth }
        set { base.layer.borderWidth = newValue }
    }
    
    public var borderColor: UIColor? {
        get {
            if let CGColor = base.layer.borderColor {
                return UIColor(cgColor: CGColor)
            } else {
                return nil
            }
        }
        set { base.layer.borderColor = newValue?.cgColor }
    }
    
    /// Setup border width & color.
    public func setBorder(
        width: CGFloat = 1.0 / UIScreen.main.scale,
        color: UIColor = UIColor.separator)
    {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
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
        
        let w = base.bounds.size.width
        let h = base.bounds.size.height
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
            base.layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.left) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: 0, y: startY),
                endPoint: CGPoint(x: 0, y: endY)
            )
            base.layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.bottom) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: startX, y: h),
                endPoint: CGPoint(x: endX, y: h)
            )
            base.layer.addSublayer(lineLayer)
        }
        
        if rectEdge.contains(.right) {
            let lineLayer = makeLineLayer(
                width: width,
                color: color,
                lineDashPattern: lineDashPattern,
                startPoint: CGPoint(x: w, y: startY),
                endPoint: CGPoint(x: w, y: endY)
            )
            base.layer.addSublayer(lineLayer)
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
            base.addSubview(lineView)
            
            let edgeConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: edge,
                relatedBy: .equal,
                toItem: base,
                attribute: edge,
                multiplier: 1,
                constant: 0
            )
            let centerConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: center,
                relatedBy: .equal,
                toItem: base,
                attribute: center,
                multiplier: 1,
                constant: 0
            )
            let sizeConstraint = NSLayoutConstraint(
                item: lineView,
                attribute: size,
                relatedBy: .equal,
                toItem: base,
                attribute: size,
                multiplier: multiplier,
                constant: constant
            )
            base.addConstraints([edgeConstraint, centerConstraint, sizeConstraint])
            
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: visualFormat,
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["lineView": lineView]
            )
            base.addConstraints(constraints)
        }
        
        if rectEdge == UIRectEdge() {
            return
        }
        
        for view in base.subviews {
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
        
        for view in base.subviews {
            if let view = view as? _BorderLineView , rectEdge.contains(view.edge) {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Corner

public extension Extension where Base: UIView {
    public var cornerRadius: CGFloat {
        get { return base.layer.cornerRadius }
        set {
            base.layer.masksToBounds = newValue > 0
            base.layer.cornerRadius = newValue
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
        if base.frame.size.equalTo(CGSize.zero) {
            logging("Could not set rounding corners on zero size view.")
            return
        }

        DispatchQueue.global().async {
            let backImage = UIImage.ext.make(
                color: fillColor ?? self.base.backgroundColor ?? UIColor.white,
                size: self.base.frame.size,
                roundingCorners: corners,
                radius: radius,
                strokeColor: strokeColor ?? self.base.backgroundColor ?? UIColor.clear,
                strokeLineWidth: strokeLineWidth
            )
            DispatchQueue.main.async {
                self.base.backgroundColor = UIColor.clear
                self.base.layer.contents = backImage?.cgImage
                self.isRoundingCornersExists = true
            }
        }
    }
    
    /// This will remove all added rounding corners on self
    public func removeRoundingCorners() {
        base.layer.contents = nil
        isRoundingCornersExists = false
    }
}

// MARK: - Blur

public extension Extension where Base: UIView {
    @available(iOS 8.0, *)
    public class func blurEffect(style: UIBlurEffectStyle = .extraLight) -> UIView {
        let blurView = UIVisualEffectView(frame: CGRect.zero)
        blurView.effect = UIBlurEffect(style: style)
        return blurView
    }
    
    @available(iOS 8.0, *)
    public func addBlurEffectView(style: UIBlurEffectStyle = .extraLight, useAutolayout: Bool = true) -> UIView {
        let blurView = UIView.ext.blurEffect(style: style)
        blurView.frame = base.bounds
        base.addSubview(blurView)
        if useAutolayout {
            blurView.translatesAutoresizingMaskIntoConstraints = false
            base.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "|[blurView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["blurView": blurView]
            ))
            base.addConstraints(NSLayoutConstraint.constraints(
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
        let speclEffectView = UIView.ext.speclEffect(style: style)
        speclEffectView.frame = base.bounds
        if useAutolayout {
            speclEffectView.translatesAutoresizingMaskIntoConstraints = false
            base.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "|[speclEffectView]|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["speclEffectView": speclEffectView]
            ))
            base.addConstraints(NSLayoutConstraint.constraints(
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

public extension Extension where Base: UIView {
    fileprivate var activityIndicatorView: UIActivityIndicatorView? {
        get { return associatedObject(forKey: &AssociationKey.activityIndicatorView) as? UIActivityIndicatorView }
        set { associate(assignObject: newValue, forKey: &AssociationKey.activityIndicatorView) }
    }
    
    fileprivate func correspondCenter(dy: CGFloat) -> CGPoint {
        var newCenter = base.center
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
        base.addSubview(activityIndicatorView)
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

// MARK: - Arc Animation

public extension Extension where Base: UIView {
    fileprivate var arcIndicatorLayer: CAShapeLayer! {
        get { return associatedObject(forKey: &AssociationKey.arcIndicatorLayer) as? CAShapeLayer }
        set { associate(assignObject: newValue, forKey: &AssociationKey.arcIndicatorLayer) }
    }
    fileprivate var stokeAnimationKey: String { return "stokeAnimation" }
    
    fileprivate func makeArcIndicatorLayer(lineWidth: CGFloat = 2, lineColor: UIColor = UIColor.lightGray) -> CAShapeLayer {
        let half = min(base.bounds.midX, base.bounds.midY)
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: base.bounds.midX, y: base.bounds.midY),
            radius: half,
            startAngle: CGFloat(-90).ext.radian,
            endAngle: CGFloat(270).ext.radian,
            clockwise: true
        )

        let arcIndicatorLayer = CAShapeLayer()
        arcIndicatorLayer.path = path.cgPath
        arcIndicatorLayer.fillColor = UIColor.clear.cgColor
        arcIndicatorLayer.strokeColor = UIColor.lightGray.cgColor
        arcIndicatorLayer.lineWidth = 2;
        arcIndicatorLayer.frame = base.bounds
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
        base.layer.addSublayer(arcIndicatorLayer)
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

public extension Extension where Base: UIView {
    fileprivate var shakeAnimationKey: String { return "shakeAnimation" }
    public func shake(horizontal: Bool = true) {
        base.layer.removeAnimation(forKey: shakeAnimationKey)
        
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
        base.layer.add(animation, forKey: shakeAnimationKey)
    }
}

// MARK: - Snapshot

public extension Extension where Base: UIView {
    public var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        if let content = UIGraphicsGetCurrentContext() {
            base.layer.render(in: content)
        } else {
            return nil
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       return image
    }
}

// MARK: - ExtendTouchRect

extension UIView {
    func _ek_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let control = self as? UIControl, !control.isEnabled || isHidden || ext.touchExtendInsets == UIEdgeInsets.zero {
            return _ek_point(inside: point, with: event)
        }
        var hitFrame = UIEdgeInsetsInsetRect(bounds, ext.touchExtendInsets)
        hitFrame.size.width = max(hitFrame.size.width, 0)
        hitFrame.size.height = max(hitFrame.size.height, 0)
        return hitFrame.contains(point)
    }
}

public extension Extension where Base: UIView {
    public var touchExtendInsets: UIEdgeInsets {
        get {
            if let value = associatedObject(forKey: &AssociationKey.touchExtendInsets) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            return UIEdgeInsets.zero
        }
        set { associate(retainObject: NSValue(uiEdgeInsets: newValue), forKey: &AssociationKey.touchExtendInsets) }
    }
}
