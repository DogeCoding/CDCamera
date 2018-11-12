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

@end
