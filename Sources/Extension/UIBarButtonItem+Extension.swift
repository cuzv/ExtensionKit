//
//  UIBarButtonItem+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 8/12/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    public class func fixedSpace(width: CGFloat) -> UIBarButtonItem {
        let spacing = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: #selector(UIBarButtonItem.doNothing))
        spacing.width = width
        return spacing
    }
    
    dynamic private func doNothing() {}
}