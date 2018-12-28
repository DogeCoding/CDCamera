//
//  NSMutableDictionary+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "NSMutableDictionary+CDAdditions.h"
#import "NSDictionary+CDAdditions.h"

@implementation NSMutableDictionary (CDAdditions)

- (void)cd_setObject:(id)anObject forKey:(id)aKey
{
    if (anObject == nil || anObject == NULL || aKey == nil)
        return;
    
    [self setObject:anObject forKey:aKey];
}

- (void)cd_setObject:(id)anObject forKey:(id)aKey withDefault:(id)def
{
    if (anObject == nil || anObject == NULL || aKey == nil)
        return;
    
    if (anObject)
        [self setObject:anObject forKey:aKey];
    else if (def)
        [self setObject:def forKey:aKey];
}

- (void)cd_addObjectWithDic:(NSDictionary *)dic
{
    for (id key in [dic allKeys]) {
        [self cd_setObject:[dic objectForKey:key] forKey:key];
    }
}

- (void)cd_addObjectWithDic:(NSDictionary *)dic withKeyArray:(NSArray *)keyArray
{
    for (id key in keyArray) {
        [self cd_setObject:[dic objectForKey:key] forKey:key];
    }
}

- (void)cd_addEntriesFromDictionary:(NSDictionary *)dictionary classes:(id)object, ...
{
    if (!dictionary.count || !object) return;
    
    NSMutableArray* classesArray = [NSMutableArray array];
    id paraObj = object;
    va_list objects;
    va_start(objects, object);
    do
    {
        [classesArray addObject:paraObj];
        paraObj = va_arg(objects, id);
    } while (paraObj);
    va_end(objects);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [dictionary cd_enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *dictionaryStop) {
        [classesArray enumerateObjectsUsingBlock:^(id clazz, NSUInteger idx, BOOL *classStop) {
            if ([obj isKindOfClass:clazz]) {
                [self setObject:obj forKey:key];
                *classStop = YES;
            }
        }];
    }];
#pragma clang diagnostic pop
}

@end
