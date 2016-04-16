//
//  UIFont+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/6/16.
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

// MARK: - Fonts

public extension UIFont {
    public class var size8Fixed: UIFont {
        return UIFont.systemFontOfSize(8.0)
    }
    
    public class var size9Fixed: UIFont {
        return UIFont.systemFontOfSize(9.0)
    }
    
    public class var size10Fixed: UIFont {
        return UIFont.systemFontOfSize(10.0)
    }
    
    public class var caption2: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
    }
    
    public class var size11: UIFont {
        return UIFont.caption2
    }
    
    public class var caption1: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }
    
    public class var size12: UIFont {
        return UIFont.caption1
    }
    
    public class var footnote: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    }
    
    public class var size13: UIFont {
        return UIFont.footnote
    }
    
    public class var size14Fixed: UIFont {
        return UIFont.systemFontOfSize(14.0)
    }
    
    public class var subheadline: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    public class var size15: UIFont {
        return UIFont.subheadline
    }
    
    public class var body: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    public class var size17: UIFont {
        return UIFont.body
    }
    
    public class var headline: UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    public class var size17Blod: UIFont {
        return UIFont.headline
    }
    
    public class var size18Fixed: UIFont {
        return UIFont.systemFontOfSize(18.0)
    }
    
    public class var size19Fixed: UIFont {
        return UIFont.systemFontOfSize(19.0)
    }
    
    public class var size20Fixed: UIFont {
        return UIFont.systemFontOfSize(20.0)
    }
    
    public class var size21Fixed: UIFont {
        return UIFont.systemFontOfSize(21.0)
    }
    
    public class var size22Fixed: UIFont {
        return UIFont.systemFontOfSize(22.0)
    }
    
    public class var size23Fixed: UIFont {
        return UIFont.systemFontOfSize(23.0)
    }
    
    public class var size24Fixed: UIFont {
        return UIFont.systemFontOfSize(24.0)
    }
    
    public class var size26Fixed: UIFont {
        return UIFont.systemFontOfSize(26.0)
    }
    
    public class var size28Fixed: UIFont {
        return UIFont.systemFontOfSize(28.0)
    }
    
    public class var size30Fixed: UIFont {
        return UIFont.systemFontOfSize(30.0)
    }
    
    public class var size32Fixed: UIFont {
        return UIFont.systemFontOfSize(32.0)
    }
    
    public class var size34Fixed: UIFont {
        return UIFont.systemFontOfSize(34.0)
    }
    
    public class var size36Fixed: UIFont {
        return UIFont.systemFontOfSize(36.0)
    }
    
    public class var size38Fixed: UIFont {
        return UIFont.systemFontOfSize(38.0)
    }
    
    public class var size40Fixed: UIFont {
        return UIFont.systemFontOfSize(40.0)
    }
    
    // MARK: - available
    
    public class var callout: UIFont {
        guard #available(iOS 9.0, *) else { fatalError("Not supported for current system version.") }
        return UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
    }
    
    public class var title3: UIFont {
        guard #available(iOS 9.0, *) else { fatalError("Not supported for current system version.") }
        return UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
    }
    
    public class var title2: UIFont {
        guard #available(iOS 9.0, *) else { fatalError("Not supported for current system version.") }
        return UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
    }

    public class var title1: UIFont {
        guard #available(iOS 9.0, *) else { fatalError("Not supported for current system version.") }
        return UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    }
}
