//
//  UIColor+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/5.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CDAdditions)

@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;

+ (UIColor *)cd_colorWithHex:(UInt32)hex;
+ (UIColor *)cd_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)cd_colorWithHexString:(NSString *)hexString;

+ (UIColor *)cd_colorWithString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
