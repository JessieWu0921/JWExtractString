//
//  UIView+CornerRaduis.m
//  JWExtractString
//
//  Created by JessieWu on 2018/8/20.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "UIView+CornerRaduis.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const char *CornerRaduisKey = "CornerRaduisKey";

@implementation UIView (CornerRaduis)

- (float)radius {
    return [objc_getAssociatedObject(self, CornerRaduisKey) floatValue];
}

- (void)setRadius:(float)radius {
    objc_setAssociatedObject(self, CornerRaduisKey, @(radius), OBJC_ASSOCIATION_ASSIGN);
    if (self.superview) {
        [self setupCornerRadius];
    }
}

+ (void)load {
    Method before = class_getInstanceMethod([self class], @selector(didMoveToSuperview));
    Method after = class_getInstanceMethod([self class], @selector(zmk_didMoveToSuperview));
    method_exchangeImplementations(before, after);
}

- (void)zmk_didMoveToSuperview {
    if (self.superview && self.radius > 0.0) {
        [self setupCornerRadius];
    }
}

- (void)setupCornerRadius {
    //组合图层避免离屏渲染
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = self.superview.backgroundColor.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.radius];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [toPath appendPath:path];
    
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.path = toPath.CGPath;
    
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer addSublayer:layer];
}

@end
