//
//  Observable.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 5/1/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation

public class Observable<T> {
    public typealias Observer = T -> ()
    private var observer: Observer?
    private var value: T {
        didSet {
            observer?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
    
    public func observe(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
