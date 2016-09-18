//
//  Observable.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 5/1/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation

open class Observable<T> {
    public typealias Observer = (T) -> ()
    fileprivate var observer: Observer?
    fileprivate var value: T {
        didSet {
            observer?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
    
    open func observe(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
