//
//
//  UIView+CDAdditions.m
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#import "UIView+CDAdditions.h"
#import <objc/runtime.h>
static void *CDCornerBorderKey = &CDCornerBorderKey;
static void *CDCornerShapeKey = &CDCornerShapeKey;

@implementation UIView (CDAdditions)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)ttScreenX {
    CGFloat x = 0;
    UIView* view = nil;
    for ( view= self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)ttScreenY {
    CGFloat y = 0;
    UIView* view = nil;
    for ( view= self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    UIView* view = nil;
    for (view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    UIView* view = nil;
    for ( view= self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)cd_applyCornerborder:(CGFloat)cornerRadius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    [self cd_applyCornerborder:cornerRadius byRoundingCorners:UIRectCornerAllCorners borderWidth:width borderColor:color];
}

- (void)cd_applyCornerborder:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    if (cornerRadius <= 0) {
        return;
    }
    if (![color isKindOfClass:[UIColor class]]) {
        color = [UIColor clearColor];
    }
    CAShapeLayer *maskLayer = objc_getAssociatedObject(self, CDCornerBorderKey);
    if (!maskLayer) {
        maskLayer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, CDCornerBorderKey, maskLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.layer.mask = maskLayer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    maskPath.lineWidth = width;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.path = maskPath.CGPath;
    maskLayer.lineWidth = width;
    [CATransaction commit];
    
    if (width > 0) {
        CAShapeLayer *shapeLayer = objc_getAssociatedObject(self, CDCornerShapeKey);
        if (!shapeLayer) {
            shapeLayer = [CAShapeLayer layer];
            objc_setAssociatedObject(self, CDCornerShapeKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [self.layer addSublayer: shapeLayer];
        UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        shapePath.lineWidth = width;
        shapeLayer.lineWidth = width;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.path = shapePath.CGPath;
        [CATransaction commit];
    }
}

@end
