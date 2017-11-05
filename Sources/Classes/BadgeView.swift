//
//  BadgeView.swift
//  Copyright (c) 2015-2016 Red Rain (http://mochxiao.com).
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

final public class BadgeView: UIView {
    fileprivate let fixedHeight: CGFloat = 18
    public var textColor: UIColor = UIColor.white
    
    let badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    public var badgeValue: String = "" {
        didSet {
            badgeLabel.text = badgeValue
            var width: CGFloat = badgeValue.layoutSize(font: badgeLabel.font).width + fixedHeight / 2
            if width < fixedHeight {
                width = fixedHeight
            }
            
            self.width = ceil(width)
            self.height = fixedHeight
            displayIfNeeded()
        }
    }
    
    fileprivate func displayIfNeeded() {
        isHidden = badgeValue.count == 0 || badgeValue == "0"
        if !isHidden {
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize : CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public override func draw(_ rect: CGRect) {
        badgeLabel.backgroundColor = backgroundColor
        layer.cornerRadius = fixedHeight / 2
        layer.masksToBounds = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        badgeLabel.backgroundColor?.setFill()
        UIRectFill(rect)
        badgeLabel.drawText(in: rect)
    }
}

// MARK:

public extension UIView {
    fileprivate struct AssociatedKey {
        static var badgeView: String = "badgeView"
    }
    
    fileprivate var badgeView: BadgeView? {
        get { return associatedObject(forKey: &AssociatedKey.badgeView) as? BadgeView }
        set { associate(assignObject: newValue, forKey: &AssociatedKey.badgeView) }
    }
    
    public var badge: String? {
        get { return badgeView?.badgeValue }
        set {
            if nil == badgeView {
                addBadgeView()
            }
            badgeView?.badgeValue = newValue ?? ""
            badgeView?.isUserInteractionEnabled = false
        }
    }
    
    public var badgeBackgroundColor: UIColor? {
        get { return badgeView?.backgroundColor }
        set {
            if nil == badgeView {
                addBadgeView()
            }
            badgeView?.backgroundColor = newValue
        }
    }
    
    public var badgeColor: UIColor? {
        get { return badgeView?.textColor }
        set {
            if nil == badgeView {
                addBadgeView()
            }
            badgeView?.textColor = newValue ?? UIColor.white
        }
    }
    
    public func setBadgeOffset(_ offset: UIOffset) {
        if nil == badgeView {
            addBadgeView()
        }
        guard let badgeView = badgeView else { return }

        var needsRemove = [NSLayoutConstraint]()
        for cons in constraints {
            if cons.firstItem as? NSObject == badgeView {
                needsRemove.append(cons)
            }
        }
        removeConstraints(needsRemove)
        
        addConstraint(NSLayoutConstraint(
            item: badgeView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: offset.horizontal
        ))
        addConstraint(NSLayoutConstraint(
            item: badgeView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: offset.vertical
        ))
    }
    
    fileprivate func addBadgeView() {
        let badgeView = BadgeView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = UIColor.red
        
        addSubview(badgeView)
        addConstraint(NSLayoutConstraint(
            item: badgeView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0
        ))
        addConstraint(NSLayoutConstraint(
            item: badgeView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        ))
        self.badgeView = badgeView
    }
    
}


