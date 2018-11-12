//
//  UIScrollView+CDScreenShot.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIScrollView+CDScreenShot.h"
#import <WebKit/WebKit.h>
#import "NSObject+CDAdditions.h"
#import "UIView+CDAdditions.h"
#import "NSObject+CDAdditions.h"
#import "EXTScope.h"
#import "metamacros.h"

@interface UIView (CDScreenShot)

@property (nonatomic, assign) BOOL isCapturing;

@property (nonatomic, assign, readonly) BOOL cdContainsWKWebView;

@end

const NSString *CDAdditionsIsCapturing = @"CDAdditionsIsCapturing";

@implementation UIView (CDScreenShot)

@dynamic isCapturing;

- (void)cdSetFrame:(CGRect)frame {
    // Do nothing, use for swizzling
}

- (BOOL)isCapturing {
    return [[self cd_objectWithAssociatedKey:&CDAdditionsIsCapturing] boolValue];
}

- (void)setIsCapturing:(BOOL)isCapturing {
    return [self cd_setObject:@(self.isCapturing) forAssociatedKey:&CDAdditionsIsCapturing associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (BOOL)cdContainsWKWebView {
    if ([self isKindOfClass:[WKWebView class]]) return YES;
    
    for (UIView *subView in self.subviews) {
        if (subView.cdContainsWKWebView) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation UIScrollView (CDScreenShot)

- (void)cdContentCaptureWithCompletionHandler:(CompletionHandler)completionHandler {
    self.isCapturing = YES;
    
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.left, self.top, self.width, self.height);
    [self.superview addSubview:snapShotView];
    
    CGRect bakFrame = self.frame;
    CGPoint bakOffset = self.contentOffset;
    UIView *bakSuperView = self.superview;
    NSUInteger bakIndex = [self.superview.subviews indexOfObject:self];
    
    if (self.height < self.contentSize.height) {
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.height);
    }
    
    @weakify(self);
    [self cdRenderImageView:^(UIImage * _Nonnull image) {
        @strongify(self);
        [self removeFromSuperview];
        self.frame = bakFrame;
        self.contentOffset = bakOffset;
        [bakSuperView insertSubview:self atIndex:bakIndex];
        
        [snapShotView removeFromSuperview];
        
        self.isCapturing = NO;
        
        completionHandler(image);
    }];
}

- (void)cdContentScrollCaptureWithProgressBlock:(ProgressBlock)progressBlock CompletionHandler:(CompletionHandler)complertionHandler {
    self.isCapturing = YES;
    
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.left, self.top, snapShotView.width, snapShotView.height);
    [self.superview addSubview:snapShotView];
    
    CGPoint bakOffset = self.contentOffset;
    CGFloat page = floorf(self.contentSize.height / self.height);
    
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, UIScreen.mainScreen.scale);
    
    NSLog(@"一共 %ld 张照片", (long)(page+1));
    
    @weakify(self);
    [self cdContentScrollPageDrawWithIndex:0 maxIndex:(NSInteger)page progressCallback:progressBlock drawCallback:^{
        @strongify(self);
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self setContentOffset:bakOffset animated:NO];
        [snapShotView removeFromSuperview];
        self.isCapturing = NO;
        complertionHandler(capturedImage);
    }];
}

- (void)cdRenderImageView:(CompletionHandler)completionHandler {
    UIView *cdTempRenderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [self removeFromSuperview];
    [cdTempRenderView addSubview:self];
    
    self.contentOffset = CGPointZero;
    self.frame = cdTempRenderView.bounds;
    
    [NSObject cd_swizzleInstanceMethodWithOriginSel:@selector(setFrame:) swizzledSel:@selector(cdSetFrame:)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGRect bounds = self.bounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, UIScreen.mainScreen.scale);
        
        if (self.cdContainsWKWebView) {
            [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
        } else {
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [NSObject cd_swizzleInstanceMethodWithOriginSel:@selector(cdSetFrame:) swizzledSel:@selector(setFrame:)];
        
        completionHandler(capturedImage);
    });
}

- (void)cdContentScrollPageDrawWithIndex:(NSInteger)index
                                maxIndex:(NSInteger)maxIndex
                        progressCallback:(ProgressBlock)progressCallback
                            drawCallback:(dispatch_block_t)drawCallback {
    NSLog(@"正在处理第 %ld 张切片", (long)index);
    
    [self setContentOffset:CGPointMake(0, index * self.height) animated:NO];
    CGRect splitFrame = CGRectMake(0, index * self.height, self.width, self.height);
    
    progressCallback(index, maxIndex);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if (index < maxIndex) {
            [self cdContentScrollPageDrawWithIndex:index + 1 maxIndex:maxIndex progressCallback:progressCallback drawCallback:drawCallback];
        } else {
            drawCallback();
        }
    });
}

@end
