//
//  UIColor+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/5.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIColor+CDAdditions.h"

CGFloat cdColorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (CDAdditions)

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)white {
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor *)cd_colorWithHex:(UInt32)hex{
    return [UIColor cd_colorWithHex:hex andAlpha:1];
}
+ (UIColor *)cd_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)cd_colorWithString:(NSString *)hexString{
    return [self cd_colorWithHexString:hexString];
}

+ (UIColor *)cd_colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = cdColorComponentFrom(colorString, 0, 1);
            green = cdColorComponentFrom(colorString, 1, 1);
            blue  = cdColorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = cdColorComponentFrom(colorString, 0, 1);
            red   = cdColorComponentFrom(colorString, 1, 1);
            green = cdColorComponentFrom(colorString, 2, 1);
            blue  = cdColorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = cdColorComponentFrom(colorString, 0, 2);
            green = cdColorComponentFrom(colorString, 2, 2);
            blue  = cdColorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = cdColorComponentFrom(colorString, 0, 2);
            red   = cdColorComponentFrom(colorString, 2, 2);
            green = cdColorComponentFrom(colorString, 4, 2);
            blue  = cdColorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
