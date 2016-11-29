//
//  UIColor+Extension.swift
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

public extension UIColor {
    public class var random: UIColor {
        let red   = CGFloat(ExtensionKit.random(in: 0 ..< 255))
        let green = CGFloat(ExtensionKit.random(in: 0 ..< 255))
        let blue  = CGFloat(ExtensionKit.random(in: 0 ..< 255))
        return UIColor.make(red: red, green: green, blue: blue)
    }
    
    public class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 100) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 100)
    }
    
    public class func make(hex: String, alpha: CGFloat = 100) -> UIColor {
        // Convert hex string to an integer
        var hexint: UInt32 = 0
        
        // Create scanner
        let scanner = Scanner(string: hex)
        
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexint)
        
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

public func UIColorFrom(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 100) -> UIColor {
    return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
}

public func UIColorFrom(hex: String, alpha: CGFloat = 100) -> UIColor {
    return UIColor.make(hex: hex, alpha: alpha)
}

// MARK: - iOS default color

public extension UIColor {
    public class var tint: UIColor {
        // 3, 122, 255, 100
        return UIColor.make(hex: "037AFF")
    }
    
    public class var separator: UIColor {
        // 200, 199, 204, 100
        return UIColor.make(hex: "C8C7CC")
    }
    
    public class var separatorDark: UIColor {
        // 69, 75, 65, 100
        return UIColor.make(hex: "454b41")
    }
    
    /// Grouped table view background.
    public class var groupedBackground: UIColor {
        // 239, 239, 244, 100
        return UIColor.make(hex: "EFEFF4")
    }
    
    /// Activity background
    public class var activityBackground: UIColor {
        // 248, 248, 248, 60
        return UIColor.make(hex: "F8F8F8", alpha: 60)
    }
    
    public class var disclosureIndicator: UIColor {
        return UIColor.make(hex: "C7C7CC")
    }

    /// Navigation bar title.
    public class var naviTitle: UIColor {
        // 3, 3, 3, 100
        return UIColor.make(hex: "030303")
    }
    
    public class var subTitle: UIColor {
        // 144, 144, 148, 100
        return UIColor.make(hex: "909094")
    }
    
    public class var placeholder: UIColor {
        // 200, 200, 205, 100
        return UIColor.make(hex: "C8C8CD")
    }
}
