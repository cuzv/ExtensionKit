//
//  Redes+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation
import Redes

// MARK: - Resonse JSON asynchronous

public extension Redes.Request  {
    public func asyncResponseJSON(completionHandler: Result<Response, AnyObject, NSError> -> ())
        -> Self
    {
        responseJSON(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), completionHandler: completionHandler)
        return self
    }
}

// MARK: - Convenience request & response

extension Requestable where Self: Responseable {
    public func asyncResponseJSON(completionHandler: Result<Response, AnyObject, NSError> -> ()) -> Request {
        return Redes.request(self).asyncResponseJSON(completionHandler)
    }
}