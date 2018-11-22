//
//  UIViewController+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/21.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CDAdditions)

+ (UIViewController *)topViewController;

- (void)jumpAlertWithTitle:(NSString*)title
                                 message:(NSString*)msg
                             cancelTitle:(NSString*)cancelTitle
                            cancelHandle:(void (^)(UIAlertAction *action))cancelHandler
                              otherTitle:(NSString*)otherTitle
                             otherHandle:(void (^)(UIAlertAction *action))otherHandle;

@end

