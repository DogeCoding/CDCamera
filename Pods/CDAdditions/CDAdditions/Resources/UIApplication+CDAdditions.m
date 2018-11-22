//
//  UIApplication+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIApplication+CDAdditions.h"

@implementation UIApplication (CDAdditions)

- (BOOL)openScheme:(id)scheme {
    return [self openScheme:scheme withCompletionHanlder:nil];
}

- (BOOL)openScheme:(id)scheme withCompletionHanlder:(CompletionHandler)completionHandler {
    NSURL *URL = [NSURL URLWithString:scheme];
    if ([self respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [self openURL:URL options:@{} completionHandler:^(BOOL success) {
           if (completionHandler) {
               completionHandler(success);
           }
        }];
        return YES;
    } else {
        return [self openURL:URL];
    }
}


@end
