//
//  UIKit+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/4/16.
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

import UIKit

@objc public protocol SetupData {
    func setupData(data: AnyObject!)
}

extension UITableViewCell: SetupData {
    public func setupData(data: AnyObject!) {}
}

extension UITableViewHeaderFooterView: SetupData {
    public func setupData(data: AnyObject!) {}
}

extension UICollectionReusableView: SetupData {
    public func setupData(data: AnyObject!) {}
}

@objc public protocol LazyLoadImagesData {
    func lazilySetupData(data: AnyObject!)
}

extension UITableViewCell: LazyLoadImagesData {
    public func lazilySetupData(data: AnyObject!) {}
}

extension UITableViewHeaderFooterView: LazyLoadImagesData {
    public func lazilySetupData(data: AnyObject!) {}
}

extension UICollectionReusableView: LazyLoadImagesData {
    public func lazilySetupData(data: AnyObject!) {}
}

public func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsMake(lhs.top + rhs.top, lhs.left + rhs.left, lhs.bottom + rhs.bottom, lhs.right + rhs.right)
}