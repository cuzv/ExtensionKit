//
//  UIColor+Extension.swift
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

public extension UIColor {
    public class var randomColor: UIColor {
        let red   = CGFloat(randomInRange(0 ..< 255))
        let green = CGFloat(randomInRange(0 ..< 255))
        let blue  = CGFloat(randomInRange(0 ..< 255))
        return UIColor.colorWithRGBA(red, green: green, blue: blue)
    }
    
    public class var defaultTintColor: UIColor {
        return UIColorFromRed(0, green: 122, blue: 255)
    }
    
    public class func colorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    public class func colorWithHex(hex: String, alpha: CGFloat = 1) -> UIColor {
        // Convert hex string to an integer
        var hexint: UInt32 = 0
        
        // Create scanner
        let scanner = NSScanner(string: hex)
        
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        scanner.scanHexInt(&hexint)
        
        // Create color object, specifying alpha
        if hex.length <= 4 {
            let divisor = CGFloat(15)
            let red     = CGFloat((hexint & 0xF00) >> 8) / divisor
            let green   = CGFloat((hexint & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hexint & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let divisor = CGFloat(255)
            let red     = CGFloat((hexint & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hexint & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hexint & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

public func UIColorFromRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
    return UIColor.colorWithRGBA(red, green: green, blue: blue, alpha: alpha)
}

public func UIColorFromHex(hex: String, alpha: CGFloat = 1) -> UIColor {
    return UIColor.colorWithHex(hex, alpha: alpha)
}

