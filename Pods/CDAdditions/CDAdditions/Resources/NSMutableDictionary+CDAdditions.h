//
//  NSMutableDictionary+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CDAdditions)

- (void)cd_setObject:(id)anObject forKey:(id)aKey;
- (void)cd_setObject:(id)anObject forKey:(id)aKey withDefault:(id)def;
- (void)cd_addObjectWithDic:(NSDictionary *)dic;
- (void)cd_addObjectWithDic:(NSDictionary *)dic withKeyArray:(NSArray *)keyArray;

- (void)cd_addEntriesFromDictionary:(NSDictionary *)dictionary classes:(id)object, ...;

@end

