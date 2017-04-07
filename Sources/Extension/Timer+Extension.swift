//
//  Timer+Extension.swift
//  ExtensionKit
//
//  Created by Haioo Inc on 4/7/17.
//  Copyright © 2017 Moch. All rights reserved.
//

import Foundation

public extension Timer {
    public func resume(after duration: TimeInterval = 0) {
        fireDate = Date(timeIntervalSinceNow: duration)
    }
    
    public func pause(after duration: TimeInterval = 0) {
        if 0 <= duration {
            fireDate = Date.distantFuture
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.fireDate = Date.distantFuture
            }
        }
    }
}

public extension CADisplayLink {
    public func resume(after duration: TimeInterval = 0) {
        if 0 <= duration {
            isPaused = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.isPaused = false
            }
        }
    }
    
    public func pause(after duration: TimeInterval = 0) {
        if 0 <= duration {
            isPaused = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.isPaused = true
            }
        }
    }
}
