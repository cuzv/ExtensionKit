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
    public class var random: UIColor {
        let red   = CGFloat(randomInRange(0 ..< 255))
        let green = CGFloat(randomInRange(0 ..< 255))
        let blue  = CGFloat(randomInRange(0 ..< 255))
        return UIColor.colorWith(red, green: green, blue: blue)
    }
    
    public class func colorWith(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 100) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 100)
    }
    
    public class func colorWith(hex: String, alpha: CGFloat = 100) -> UIColor {
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
            return UIColor(red: red, green: green, blue: blue, alpha: alpha / 100)
        } else {
            let divisor = CGFloat(255)
            let red     = CGFloat((hexint & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hexint & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hexint & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha / 100)
        }
    }
}

public func UIColorFrom(red red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 100) -> UIColor {
    return UIColor.colorWith(red, green: green, blue: blue, alpha: alpha)
}

public func UIColorFrom(hex hex: String, alpha: CGFloat = 100) -> UIColor {
    return UIColor.colorWith(hex, alpha: alpha)
}

// MARK: - iOS default color

public extension UIColor {
    public class var tintColor: UIColor {
        // 3, 122, 255, 100
        return UIColorFrom(hex: "037AFF")
    }
    
    public class var separatorDefaultColor: UIColor {
        // 200, 199, 204, 100
        return UIColorFrom(hex: "C8C7CC")
    }
    
    public class var separatorDarkColor: UIColor {
        // 69, 75, 65, 100
        return UIColorFrom(hex: "454b41")
    }
    
    /// Grouped table view background.
    public class var groupedBackgroundColor: UIColor {
        // 239, 239, 244, 100
        return UIColorFrom(hex: "EFEFF4")
    }
    
    /// Activity background
    public class var activityBackgroundColor: UIColor {
        // 248, 248, 248, 60
        return UIColorFrom(hex: "F8F8F8", alpha: 60)
    }
    
    public class var disclosureIndicatorColor: UIColor {
        return UIColorFrom(hex: "C7C7CC")
    }

    /// Navigation bar title.
    public class var naviTitleColor: UIColor {
        // 3, 3, 3, 100
        return UIColorFrom(hex: "030303")
    }
    
    public class var subColor: UIColor {
        // 144, 144, 148, 100
        return UIColorFrom(hex: "909094")
    }
    
    public class var placeholderColor: UIColor {
        // 200, 200, 205, 100
        return UIColorFrom(hex: "C8C8CD")
    }
}
