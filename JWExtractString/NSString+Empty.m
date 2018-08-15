//
//  NSString+Empty.m
//  JWExtractString
//
//  Created by JessieWu on 2018/8/14.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "NSString+Empty.h"

#import <objc/runtime.h>

@interface NSString()

@property (nonatomic, assign, readwrite, getter=isEmpty) BOOL empty;

@end

@implementation NSString (Empty)

- (BOOL)isEmpty {
    [self checkEmpty];
    return [objc_getAssociatedObject(self, @"StringEmptyKey") boolValue];
}

- (void)setEmpty:(BOOL)empty {
    objc_setAssociatedObject(self, @"StringEmptyKey", @(empty), OBJC_ASSOCIATION_ASSIGN);
}

- (void)checkEmpty {
    if (self == nil || self.length == 0 || (self.length == 1 && [self isEqualToString:@" "]) || [self isEqualToString:@""]) {
        self.empty = YES;
    } else {
        self.empty = NO;
    }
}

@end
