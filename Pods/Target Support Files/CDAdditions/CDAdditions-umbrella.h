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
#import "CDTypeCastUtil.h"
#import "EXTScope.h"
#import "metamacros.h"
#import "NSArray+CDAdditions.h"
#import "NSDictionary+CDAdditions.h"
#import "NSMutableArray+CDAdditions.h"
#import "NSMutableDictionary+CDAdditions.h"
#import "NSObject+CDAdditions.h"
#import "NSString+CDAdditions.h"
#import "UIAlertController+CDAdditions.h"
#import "UIApplication+CDAdditions.h"
#import "UIButton+CDAdditions.h"
#import "UIColor+CDAdditions.h"
#import "UIDevice+CDAdditions.h"
#import "UIFont+CDAdditions.h"
#import "UIScrollView+CDScreenShot.h"
#import "UIView+CDAdditions.h"
#import "UIViewController+CDAdditions.h"

FOUNDATION_EXPORT double CDAdditionsVersionNumber;
FOUNDATION_EXPORT const unsigned char CDAdditionsVersionString[];

