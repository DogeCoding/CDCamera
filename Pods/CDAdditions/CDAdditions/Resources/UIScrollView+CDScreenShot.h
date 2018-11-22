//
//  UIScrollView+CDScreenShot.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/12.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CDScreenShot)

typedef void(^FinishBlock) (UIImage *image);
typedef void(^ProgressBlock)(NSInteger current, NSInteger total);

- (void)cdContentCaptureWithFinishBlock:(FinishBlock)finishBlock;

- (void)cdContentScrollCaptureWithProgressBlock:(ProgressBlock)progressBlock finishBlock:(FinishBlock)finishBlock;

@end
