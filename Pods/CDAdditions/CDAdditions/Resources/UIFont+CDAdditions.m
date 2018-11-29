//
//
//  UIFont+CDAdditions.m
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#import "UIFont+CDAdditions.h"

@implementation UIFont (CDAdditions)

+ (nullable UIFont *)cd_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)boldPingFangFontWithSize:(CGFloat)size {
    return [UIFont cd_fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (UIFont *)regularPingFangFontWithSize:(CGFloat)size {
    return [UIFont cd_fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)thinPingFangFontWithSize:(CGFloat)size {
    return [UIFont cd_fontWithName:@"PingFangSC-Thin" size:size];
}

+ (UIFont *)mediumPingFangFontWithSize:(CGFloat)size {
    return [UIFont cd_fontWithName:@"PingFangSC-Medium" size:size];
}

@end
