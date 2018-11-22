//
//  UIAlertController+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIAlertController+CDAdditions.h"

@implementation UIAlertController (CDAdditions)

+ (UIAlertController *)alertWithTitle:(NSString *)title
                              message:(NSString *)msg
                          cancelTitle:(NSString *)cancelTitle
                         cancelHandle:(void (^)(UIAlertAction *))cancelHandler
                           otherTitle:(NSString *)otherTitle
                          otherHandle:(void (^)(UIAlertAction *))otherHandle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle.length > 0) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelHandler];
        [alert addAction:cancel];
    }
    
    if (otherTitle.length > 0) {
        UIAlertAction *other = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:otherHandle];
        [alert addAction:other];
        if (@available(iOS 9.0, *)) {
            alert.preferredAction = other;
        }
    }
    return alert;
}

@end
