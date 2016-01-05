//
//  UIScreen+Extension.swift
//  MicroShop
//
//  Created by Moch Xiao on 12/30/15.
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

public extension UIScreen {
    private static let _sharedApplication  = UIApplication.sharedApplication()
    private static let _isLandscape        = UIInterfaceOrientationIsLandscape(_sharedApplication.statusBarOrientation)
    private static let _iOS8Plus           = Float(UIDevice.systemVersion) >= 8.0
    private static let _mainScreen         = UIScreen.mainScreen()

    private static let _nativeBounds       = _mainScreen.nativeBounds
    private static let _nativeBoundsSize   = _nativeBounds.size
    private static let _nativeBoundsHeight = _nativeBoundsSize.height
    private static let _nativeBoundsWidth  = _nativeBoundsSize.width
    private static let _nativeScale        = _mainScreen.nativeScale

    private static let _bounds             = _mainScreen.bounds
    private static let _boundsSize         = _bounds.size
    private static let _boundsHeight       = _boundsSize.height
    private static let _boundsWidth        = _boundsSize.width

    private static let _statusBarWidth       = _sharedApplication.statusBarFrame.size.width
    private static let _statusBarHeight     = _sharedApplication.statusBarFrame.size.height
    
    private class func screenWidth() -> CGFloat {
        if _isLandscape {
            if _iOS8Plus {
                return _nativeBoundsHeight / _nativeScale
            } else {
                return _boundsHeight
            }
        } else {
            if _iOS8Plus {
                return _nativeBoundsWidth / _nativeScale
            } else {
                return _boundsWidth
            }
        }
    }
    
    private class func screenHeight() -> CGFloat {
        if _isLandscape {
            if _iOS8Plus {
                if _statusBarWidth > 20 {
                    return _nativeBoundsWidth / _nativeScale - 20
                }
                return _nativeBoundsWidth / _nativeScale
            } else {
                if _statusBarWidth > 20 {
                    return _boundsWidth - 20
                }
                return _boundsWidth
            }
        } else {
            if _iOS8Plus {
                if _statusBarHeight > 20 {
                    return _nativeBoundsHeight / _nativeScale - 20
                }
                return _nativeBoundsHeight / _nativeScale
            } else {
                if _statusBarHeight > 20 {
                    return _boundsHeight - 20
                }
                return _boundsHeight
            }
        }
    }
    
    private class func screenScale() -> CGFloat {
        if _iOS8Plus {
            return _nativeScale
        } else {
            return UIScreen.mainScreen().scale()
        }
    }
    
    public class var width: CGFloat {
        return UIScreen.screenWidth()
    }
    
    public class var height: CGFloat {
        return UIScreen.screenHeight()
    }
    
    public class var scale: CGFloat {
        return UIScreen.screenScale()
    }
}
