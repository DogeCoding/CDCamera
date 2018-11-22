//
//
//  CDConstant.h
//  OCDemo
//
//  Created by CodingDoge on 2018/10/18.
//
    

#ifndef CDConstant_h
#define CDConstant_h

#pragma mark --- UI ---

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0\
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0\
                                                  blue:((float)(rgbValue & 0xFF))/255.0\
                                                 alpha:1]\

#define UIColorFromRGBWithAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0\
                                                                     green:((float)((rgbValue & 0xFF00) >> 8))/255.0\
                                                                      blue:((float)(rgbValue & 0xFF))/255.0\
                                                                     alpha:alphaValue]

#define RandomColor [UIColor colorWithHue:( arc4random() % 256 / 256.0 )\
                               saturation:((arc4random() % 128 / 256.0 ) + 0.5)\
                               brightness:(( arc4random() % 128 / 256.0 ) + 0.5)\
                                    alpha:1.0];

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenScale (1.0/([UIScreen mainScreen].scale))

#pragma mark --- Memory ---


#pragma mark --- Multithreading ---

#define dispatch_main_async(block) \
if ([NSThread isMainThread]) {  \
block();    \
} else {    \
dispatch_async(dispatch_get_main_queue(), block);   \
}

#endif /* CDConstant_h */
