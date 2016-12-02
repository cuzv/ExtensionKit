//
//  UIScrollView+Extension.swift
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

public extension Extension where Base: UIScrollView {
    public var insetTop: CGFloat {
        get { return base.contentInset.top }
        set {
            var inset = base.contentInset
            inset.top = newValue
            base.contentInset = inset
        }
    }
    
    public var insetLeft: CGFloat {
        get { return base.contentInset.left }
        set {
            var inset = base.contentInset
            inset.left = newValue
            base.contentInset = inset
        }
    }
    
    public var insetBottom: CGFloat {
        get { return base.contentInset.bottom }
        set {
            var inset = base.contentInset
            inset.bottom = newValue
            base.contentInset = inset
        }
    }
    
    public var insetRight: CGFloat {
        get { return base.contentInset.right }
        set {
            var inset = base.contentInset
            inset.right = newValue
            base.contentInset = inset
        }
    }
    
    public var scrollIndicatorInsetTop: CGFloat {
        get { return  base.scrollIndicatorInsets.top }
        set {
            
            var inset = base.scrollIndicatorInsets
            inset.top = newValue
            base.scrollIndicatorInsets = inset
        }
    }
    
    public var scrollIndicatorInsetLeft: CGFloat {
        get { return base.scrollIndicatorInsets.left }
        set {
            var inset = base.scrollIndicatorInsets
            inset.left = newValue
            base.scrollIndicatorInsets = inset
        }
    }
    
    public var scrollIndicatorInsetBottom: CGFloat {
        get { return base.scrollIndicatorInsets.bottom }
        set {
            var inset = base.scrollIndicatorInsets
            inset.bottom = newValue
            base.scrollIndicatorInsets = inset
        }
    }
    
    public var scrollIndicatorInsetRight: CGFloat {
        get { return base.scrollIndicatorInsets.right }
        set {
            var inset = base.scrollIndicatorInsets
            inset.right = newValue
            base.scrollIndicatorInsets = inset
        }
    }
    
    public var contentOffsetX: CGFloat {
        get { return base.contentOffset.x }
        set {
            var offset = base.contentOffset
            offset.x = newValue
            base.contentOffset = offset
        }
    }
    
    public var contentOffsetY: CGFloat {
        get { return base.contentOffset.y }
        set {
            var offset = base.contentOffset
            offset.y = newValue
            base.contentOffset = offset
        }
    }
    
    public var contentSizeWidth: CGFloat {
        get { return base.contentSize.width }
        set {
            var size = base.contentSize
            size.width = newValue
            base.contentSize = size
        }
    }
    
    public var contentSizeHeight: CGFloat {
        get { return base.contentSize.height }
        set {
            var size = base.contentSize
            size.height = newValue
            base.contentSize = size
        }
    }
}

// MARK: - RefreshControl

fileprivate struct AssociationKey {
    fileprivate static var refreshControl: String = "com.mochxiao.uiscrollview.RefreshControl"
}

public extension Extension where Base: UIScrollView {
    public private(set) var refreshContrl: UIRefreshControl? {
        get { return associatedObject(forKey: &AssociationKey.refreshControl) as? UIRefreshControl }
        set { associate(assignObject: newValue, forKey: &AssociationKey.refreshControl) }
    }
    
    public func addRefreshControl(withActionHandler handler: @escaping ((UIScrollView) -> ())) {
        if let _ = refreshContrl {
            return
        }
        
        let _refreshContrl = UIRefreshControl(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 64
        ))
        base.addSubview(_refreshContrl)
        base.sendSubview(toBack: _refreshContrl)
        _refreshContrl.ext.addControlEvents(.valueChanged) { [weak self] (_) in
            if let this = self {
                if this.refreshControlEnabled {
                    handler(this.base)
                } else {
                    this.endRefreshing()
                }
            }
        }
        refreshContrl = _refreshContrl
    }
    
    public private(set) var refreshControlEnabled: Bool {
        get {
            if let refreshContrl = refreshContrl {
                return refreshContrl.isEnabled
            }
            return false
        }
        set {
            if let refreshContrl = refreshContrl {
                refreshContrl.isEnabled = newValue
                refreshContrl.alpha = newValue ? 1 : 0
            }
        }
    }
    
    public func beginRefreshing() {
        refreshContrl?.beginRefreshing()
    }
    
    public func endRefreshing() {
        refreshContrl?.endRefreshing()
    }
    
    public var refreshing: Bool {
        if let refreshContrl = refreshContrl {
            return refreshContrl.isRefreshing
        }
        return false
    }
}
