//
//  ObjcSwizzle.m
//  ExtensionKit
//
//  Created by Moch Xiao on 3/31/17.
//  Copyright © 2017 Moch. All rights reserved.
//

#import "ObjcSwizzle.h"
#import <ExtensionKit/ExtensionKit-Swift.h>

void EKSwizzleInstanceMethod(Class _Nonnull clazz,  SEL _Nonnull originalSelector, SEL _Nonnull overrideSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method overrideMethod = class_getInstanceMethod(clazz, overrideSelector);
    
    if (class_addMethod(clazz, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(clazz, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

#pragma mark -

@implementation UIView (ObjcSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UIView.class) {
            EKSwizzleInstanceMethod(self.class, @selector(pointInside:withEvent:), @selector(_ek_pointInside:with:));
        }
    });
}

@end

#pragma mark - 

@implementation UILabel (ObjcSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UILabel.class) {
            EKSwizzleInstanceMethod(self.class, @selector(intrinsicContentSize), @selector(_ek_intrinsicContentSize));
            EKSwizzleInstanceMethod(self.class, @selector(drawInRect:), @selector(_ek_drawTextIn:));
        }
    });
}

@end

#pragma mark - 

@implementation UITextField (ObjcSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UITextField.class) {
            EKSwizzleInstanceMethod(self.class, @selector(intrinsicContentSize), @selector(_ek_intrinsicContentSize));
            EKSwizzleInstanceMethod(self.class, @selector(textRectForBounds:), @selector(_ek_textRectForBounds:));
            EKSwizzleInstanceMethod(self.class, @selector(editingRectForBounds:), @selector(_ek_editingRectForBounds:));
        }
    });
}

@end
