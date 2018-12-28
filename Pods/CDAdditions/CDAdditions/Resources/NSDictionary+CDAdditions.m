//
//  NSDictionary+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "NSDictionary+CDAdditions.h"
#import "CDTypeCastUtil.h"

@implementation NSDictionary (CDAdditions)

/**
 *  返回根据所给key值在当前字典对象上对应的值.
 */
#define OFK [self objectForKey:key]

- (BOOL)cd_hasKey:(NSString *)key
{
    return (OFK != nil);
}

#pragma mark - NSObject

- (id)cd_objectForKey:(NSString *)key
{
    return OFK;
}

- (id)cd_unknownObjectForKey:(NSString*)key
{
    return OFK;
}


- (id)cd_objectForKey:(NSString *)key class:(Class)clazz
{
    id obj = OFK;
    if ([obj isKindOfClass:clazz])
    {
        return obj;
    }
    
    return nil;
}

#pragma mark - NSNumber

- (NSNumber *)cd_numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    return cd_numberOfValue(OFK, defaultValue);
}

- (NSNumber *)cd_numberForKey:(NSString *)key
{
    return [self cd_numberForKey:key defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)cd_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    return cd_stringOfValue(OFK, defaultValue);
}

- (NSString *)cd_stringForKey:(NSString *)key;
{
    return [self cd_stringForKey:key defaultValue:nil];
}

#pragma mark - NSArray of NSString

- (NSArray *)cd_stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return cd_stringArrayOfValue(OFK, defaultValue);
}

- (NSArray *)cd_stringArrayForKey:(NSString *)key;
{
    return [self cd_stringArrayForKey:key defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)cd_dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    return cd_dictOfValue(OFK, defaultValue);
}

- (NSDictionary *)cd_dictForKey:(NSString *)key
{
    return [self cd_dictForKey:key defaultValue:nil];
}

- (NSDictionary *)cd_dictionaryWithValuesForKeys:(NSArray *)keys
{
    return [self dictionaryWithValuesForKeys:keys];
}

#pragma mark - NSArray

- (NSArray *)cd_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return cd_arrayOfValue(OFK, defaultValue);
}

- (NSArray *)cd_arrayForKey:(NSString *)key
{
    return [self cd_arrayForKey:key defaultValue:nil];
}

#pragma mark - Float

- (float)cd_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
{
    return cd_floatOfValue(OFK, defaultValue);
}

- (float)cd_floatForKey:(NSString *)key;
{
    return [self cd_floatForKey:key defaultValue:0.0f];
}

#pragma mark - Double

- (double)cd_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
{
    return cd_doubleOfValue(OFK, defaultValue);
}

- (double)cd_doubleForKey:(NSString *)key;
{
    return [self cd_doubleForKey:key defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)cd_pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue
{
    return cd_pointOfValue(OFK, defaultValue);
}

- (CGPoint)cd_pointForKey:(NSString *)key;
{
    return [self cd_pointForKey:key defaultValue:NSZeroPoint];
}

#pragma mark - CGSize

- (CGSize)cd_sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
{
    return cd_sizeOfValue(OFK, defaultValue);
}

- (CGSize)cd_sizeForKey:(NSString *)key;
{
    return [self cd_sizeForKey:key defaultValue:NSZeroSize];
}

#pragma mark - CGRect

- (CGRect)cd_rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
{
    return cd_rectOfValue(OFK, defaultValue);
}

- (CGRect)cd_rectForKey:(NSString *)key;
{
    return [self cd_rectForKey:key defaultValue:NSZeroRect];
}

#pragma mark - BOOL

- (BOOL)cd_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
{
    return cd_boolOfValue(OFK, defaultValue);
}

- (BOOL)cd_boolForKey:(NSString *)key;
{
    return [self cd_boolForKey:key defaultValue:NO];
}

#pragma mark - Int

- (int)cd_intForKey:(NSString *)key defaultValue:(int)defaultValue;
{
    return cd_intOfValue(OFK, defaultValue);
}

- (int)cd_intForKey:(NSString *)key;
{
    return [self cd_intForKey:key defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)cd_unsignedIntForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;
{
    return cd_unsignedIntOfValue(OFK, defaultValue);
}

- (unsigned int)cd_unsignedIntForKey:(NSString *)key;
{
    return [self cd_unsignedIntForKey:key defaultValue:0];
}

#pragma mark - Long Long

- (long long int)cd_longLongForKey:(NSString *)key defaultValue:(long long int)defaultValue
{
    return cd_longLongOfValue(OFK, defaultValue);
}

- (long long int)cd_longLongForKey:(NSString *)key;
{
    return [self cd_longLongForKey:key defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)cd_unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
{
    return cd_unsignedLongLongOfValue(OFK, defaultValue);
}

- (unsigned long long int)cd_unsignedLongLongForKey:(NSString *)key;
{
    return [self cd_unsignedLongLongForKey:key defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)cd_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
{
    return cd_integerOfValue(OFK, defaultValue);
}

- (NSInteger)cd_integerForKey:(NSString *)key;
{
    return [self cd_integerForKey:key defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)cd_unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
    return cd_unsignedIntegerOfValue(OFK, defaultValue);
}

- (NSUInteger)cd_unsignedIntegerForKey:(NSString *)key
{
    return [self cd_unsignedIntegerForKey:key defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)cd_imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue
{
    return cd_imageOfValue(OFK, defaultValue);
}

- (UIImage *)cd_imageForKey:(NSString *)key
{
    return [self cd_imageForKey:key defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)cd_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue
{
    return cd_colorOfValue(OFK, defaultValue);
}

- (UIColor *)cd_colorForKey:(NSString *)key
{
    return [self cd_colorForKey:key defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)cd_timeForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    return cd_timeOfValue(OFK, defaultValue);
}

- (time_t)cd_timeForKey:(NSString *)key
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self cd_timeForKey:key defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)cd_dateForKey:(NSString *)key
{
    return cd_dateOfValue(OFK);
}

#pragma mark - Enumerate

- (void)cd_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)cd_enumerateKeysAndUnknownObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)cd_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)cd_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block classes:(id)object, ...
{
    if (!object) return;
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
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL allowBlock = NO;
        for (int i = 0; i < classesArray.count; i++)
        {
            if ([obj isKindOfClass:[classesArray objectAtIndex:i]])
            {
                allowBlock = YES;
                break;
            }
        }
        if (allowBlock)
        {
            block(key, obj, stop);
        }
    }];
}

- (void)cd_enumerateKeysAndArrayObjectsUsingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsUsingBlock:block withCastFunction:cd_arrayOfValue];
}

- (void)cd_enumerateKeysAndDictObjectsUsingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsUsingBlock:block withCastFunction:cd_dictOfValue];
}

- (void)cd_enumerateKeysAndStringObjectsUsingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsUsingBlock:block withCastFunction:cd_stringOfValue];
}

- (void)cd_enumerateKeysAndNumberObjectsUsingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsUsingBlock:block withCastFunction:cd_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)cd_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
}

- (void)cd_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)cd_enumerateKeysAndArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:cd_arrayOfValue];
}

- (void)cd_enumerateKeysAndDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:cd_dictOfValue];
}

- (void)cd_enumerateKeysAndStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:cd_stringOfValue];
}

- (void)cd_enumerateKeysAndNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self cd_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:cd_numberOfValue];
}

@end
