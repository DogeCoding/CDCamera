//
//  UIApplication+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/22.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(BOOL isSuccess);

@interface UIApplication (CDAdditions)

- (BOOL)openScheme:(NSString *)scheme;
- (BOOL)openScheme:(NSString *)scheme withCompletionHanlder:(CompletionHandler)completionHandler;

@end

