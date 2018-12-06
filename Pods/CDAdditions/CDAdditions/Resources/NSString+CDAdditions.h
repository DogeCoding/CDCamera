//
//
//  NSString+CDAdditions.h
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CDAdditions)

#pragma mark - 编码解码

- (NSString *)md5;
- (NSString *)URLEncodedString;

#pragma mark - 文本size
- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing;

- (CGSize)cd_sizeWithFont:(UIFont *)font;
- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width;
- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)cd_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing;
- (CGSize)cd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark - 格式化
+ (NSString *)currentDate;

@end

