//
//  UIBarButtonItem+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 8/12/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    public class func fixedSpace(_ width: CGFloat) -> UIBarButtonItem {
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = width
        return spacing
    }
}
