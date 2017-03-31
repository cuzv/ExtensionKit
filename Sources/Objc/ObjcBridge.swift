//
//  ObjcBridge.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 3/31/17.
//  Copyright © 2017 Moch. All rights reserved.
//

import Foundation

// See http://stackoverflow.com/questions/42824541/swift-3-1-deprecates-initialize-how-can-i-achieve-the-same-thing
public protocol SelfAware: class {
    static func awake()
}

@objc public class ObjcBridge: NSObject {
    static func objc_load() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount { (types[index] as? SelfAware.Type)?.awake() }
        types.deallocate(capacity: typeCount)
    }
}

// MARK: - Swizzle

extension UIView: SelfAware {
    public static func awake() {
        if self == UIView.self {
            swizzleView()
        }
        if self == UITextField.self {
            UITextField.swizzleTextField()
        }
        if self == UILabel.self {
            UILabel.swizzleLabel()
        }
    }
}
