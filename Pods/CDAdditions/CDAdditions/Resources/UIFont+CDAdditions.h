//
//
//  UIFont+CDAdditions.h
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#import <UIKit/UIKit.h>

@interface UIFont (CDAdditions)

+ (nullable UIFont *)cd_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

+ (UIFont *)boldPingFangFontWithSize:(CGFloat)size;

+ (UIFont *)regularPingFangFontWithSize:(CGFloat)size;

+ (UIFont *)thinPingFangFontWithSize:(CGFloat)size;

+ (UIFont *)mediumPingFangFontWithSize:(CGFloat)size;

@end

