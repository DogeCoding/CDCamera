//
//
//  NSString+CDAdditions.m
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#import "NSString+CDAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CDAdditions)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString
{
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing {
    if (nil == font) {
        assert(0);
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle* paragrap = [[NSMutableParagraphStyle alloc] init];
    paragrap.lineBreakMode = lineBreakMode;
    
    if (lineSpacing > 0) {
        paragrap.lineSpacing = lineSpacing;
    }
    
    NSDictionary* attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragrap };
    
    CGRect stringBound = [self boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    
    return CGSizeMake(ceil(stringBound.size.width), ceil(stringBound.size.height));
}


- (CGSize)cd_sizeWithFont:(UIFont *)font {
    return [self cd_sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self cd_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width {
    return [self cd_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self cd_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing {
    return [self cd_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode lineSpacing:lineSpacing];
}

- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self cd_sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode lineSpacing:0];
}

@end
