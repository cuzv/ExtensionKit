//
//  BadgeView.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 3/28/16.
//  Copyright © @2016 Moch Xiao (http://mochxiao.com).
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
    private let fixedHeight: CGFloat = 18
    public var textColor: UIColor = UIColor.whiteColor()
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        label.lineBreakMode = .ByTruncatingTail
        label.textAlignment = .Center
        label.backgroundColor = self.backgroundColor
        return label
    }()
    
    public var badgeValue: String = "" {
        didSet {
            badgeLabel.text = badgeValue
            var width: CGFloat = badgeValue.size(withFont: badgeLabel.font).width + fixedHeight / 2
            if width < fixedHeight {
                width = fixedHeight
            }
            
            self.width = ceil(width)
            self.height = fixedHeight
            displayIfNeeded()
        }
    }
    
    private func displayIfNeeded() {
        hidden = badgeValue.length == 0 || badgeValue == "0"
        if !hidden {
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds))
    }
    
    public override func drawRect(rect: CGRect) {
        layer.cornerRadius = fixedHeight / 2
        layer.masksToBounds = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        badgeLabel.backgroundColor?.setFill()
        UIRectFill(rect)
        badgeLabel.drawTextInRect(rect)
    }
}

// MARK:

public extension UIView {
    private struct AssociatedKey {
        static var badgeView: String = "badgeView"
    }
    
    private var badgeView: BadgeView? {
        get { return associatedObjectForKey(&AssociatedKey.badgeView) as? BadgeView }
        set { associate(assignObject: newValue, forKey: &AssociatedKey.badgeView) }
    }
    
    public var badgeText: String? {
        get { return badgeView?.badgeValue }
        set {
            if nil == badgeView {
                addBadgeView()
            }
            badgeView?.badgeValue = newValue ?? ""
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
            badgeView?.textColor = newValue ?? UIColor.whiteColor()
        }
    }
    
    public func setBadgeOffset(offset: UIOffset) {
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
        
        addConstraint(NSLayoutConstraint(item: badgeView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: offset.horizontal))
        addConstraint(NSLayoutConstraint(item: badgeView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: offset.vertical))
    }
    
    private func addBadgeView() {
        let badgeView = BadgeView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = UIColor.redColor()
        
        addSubview(badgeView)
        addConstraint(NSLayoutConstraint(item: badgeView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: badgeView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))

        self.badgeView = badgeView
    }
    
}


