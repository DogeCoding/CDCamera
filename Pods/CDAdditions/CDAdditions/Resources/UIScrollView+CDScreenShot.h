//
//  UIScrollView+CDScreenShot.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionHandler) (UIImage *image);
typedef void(^ProgressBlock)(NSInteger current, NSInteger total);

@interface UIScrollView (CDScreenShot)

- (void)cdContentCaptureWithCompletionHandler:(CompletionHandler)completionHandler;

- (void)cdContentScrollCaptureWithProgressBlock:(ProgressBlock)progressBlock CompletionHandler:(CompletionHandler)complertionHandler;

@end

NS_ASSUME_NONNULL_END
