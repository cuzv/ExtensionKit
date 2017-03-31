//
//  UIApplication+ObjcBridge.m
//  ExtensionKit
//
//  Created by Moch Xiao on 3/31/17.
//  Copyright © 2017 Moch. All rights reserved.
//

#import "UIApplication+ObjcBridge.h"
#import <ExtensionKit/ExtensionKit-Swift.h>

@implementation UIApplication (ObjcBridge)

+ (void)load {
    [ObjcBridge objc_load];
}

@end
