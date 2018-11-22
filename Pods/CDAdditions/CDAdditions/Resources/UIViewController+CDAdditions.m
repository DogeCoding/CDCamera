//
//  UIViewController+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/21.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIViewController+CDAdditions.h"
#import "UIAlertController+CDAdditions.h"

@implementation UIViewController (CDAdditions)

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [UIViewController _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [UIViewController _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

-(void)jumpAlertWithTitle:(NSString*)title
                                 message:(NSString*)msg
                             cancelTitle:(NSString*)cancelTitle
                            cancelHandle:(void (^ __nullable)(UIAlertAction *action))cancelHandler
                              otherTitle:(NSString*)otherTitle
                             otherHandle:(void (^ __nullable)(UIAlertAction *action))otherHandle
{
    UIAlertController *alert = [UIAlertController alertWithTitle:title
                                                         message:msg
                                                     cancelTitle:cancelTitle
                                                    cancelHandle:cancelHandler
                                                      otherTitle:otherTitle
                                                     otherHandle:otherHandle];
    
    [self presentViewController:alert animated:NO completion:nil];
}

@end
