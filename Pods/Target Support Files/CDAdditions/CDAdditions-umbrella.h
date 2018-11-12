#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CDAdditions.h"
#import "CDConstant.h"
#import "CDCoordinateAdditions.h"
#import "EXTScope.h"
#import "metamacros.h"
#import "NSObject+CDAdditions.h"
#import "NSString+CDAdditions.h"
#import "UIColor+CDAdditions.h"
#import "UIDevice+CDAdditions.h"
#import "UIFont+CDAdditions.h"
#import "UIScrollView+CDScreenShot.h"
#import "UIView+CDAdditions.h"

FOUNDATION_EXPORT double CDAdditionsVersionNumber;
FOUNDATION_EXPORT const unsigned char CDAdditionsVersionString[];

