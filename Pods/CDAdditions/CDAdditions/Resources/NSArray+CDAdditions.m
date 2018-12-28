//
//  NSArray+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "NSArray+CDAdditions.h"
#import "CDTypeCastUtil.h"

@implementation NSArray (CDAdditions)

#define OAI [self cd_safeObjectAtIndex:index]

- (id)cd_safeObjectAtIndex:(NSUInteger)index
{
    return (index >= self.count) ? nil : [self objectAtIndex:index];
}

#pragma mark - NSObject

- (id)cd_objectAtIndex:(NSUInteger)index
{
    return OAI;
}

#pragma mark - NSNumber

- (NSNumber *)cd_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)defaultValue
{
    return cd_numberOfValue(OAI, defaultValue);
}

- (NSNumber *)cd_numberAtIndex:(NSUInteger)index
{
    return [self cd_numberAtIndex:index defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)cd_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)defaultValue;
{
    return cd_stringOfValue(OAI, defaultValue);
}

- (NSString *)cd_stringAtIndex:(NSUInteger)index;
{
    return [self cd_stringAtIndex:index defaultValue:nil];
}

#pragma mark - NSArray of NSString

- (NSArray *)cd_stringArrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
    return cd_stringArrayOfValue(OAI, defaultValue);
}

- (NSArray *)cd_stringArrayAtIndex:(NSUInteger)index;
{
    return [self cd_stringArrayAtIndex:index defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)cd_dictAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)defaultValue
{
    return cd_dictOfValue(OAI, defaultValue);
}

- (NSDictionary *)cd_dictAtIndex:(NSUInteger)index
{
    return [self cd_dictAtIndex:index defaultValue:nil];
}

#pragma mark - NSArray

- (NSArray *)cd_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
    return cd_arrayOfValue(OAI, defaultValue);
}

- (NSArray *)cd_arrayAtIndex:(NSUInteger)index
{
    return [self cd_arrayAtIndex:index defaultValue:nil];
}

#pragma mark - Float

- (float)cd_floatAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;
{
    return cd_floatOfValue(OAI, defaultValue);
}

- (float)cd_floatAtIndex:(NSUInteger)index;
{
    return [self cd_floatAtIndex:index defaultValue:0.0f];
}

#pragma mark - Double

- (double)cd_doubleAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;
{
    return cd_doubleOfValue(OAI, defaultValue);
}

- (double)cd_doubleAtIndex:(NSUInteger)index;
{
    return [self cd_doubleAtIndex:index defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)cd_pointAtIndex:(NSUInteger)index defaultValue:(CGPoint)defaultValue
{
    return cd_pointOfValue(OAI, defaultValue);
}

- (CGPoint)cd_pointAtIndex:(NSUInteger)index;
{
    return [self cd_pointAtIndex:index defaultValue:NSZeroPoint];
}

#pragma mark - CGSize

- (CGSize)cd_sizeAtIndex:(NSUInteger)index defaultValue:(CGSize)defaultValue;
{
    return cd_sizeOfValue(OAI, defaultValue);
}

- (CGSize)cd_sizeAtIndex:(NSUInteger)index;
{
    return [self cd_sizeAtIndex:index defaultValue:NSZeroSize];
}

#pragma mark - CGRect

- (CGRect)cd_rectAtIndex:(NSUInteger)index defaultValue:(CGRect)defaultValue;
{
    return cd_rectOfValue(OAI, defaultValue);
}

- (CGRect)cd_rectAtIndex:(NSUInteger)index;
{
    return [self cd_rectAtIndex:index defaultValue:NSZeroRect];
}

#pragma mark - BOOL

- (BOOL)cd_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;
{
    return cd_boolOfValue(OAI, defaultValue);
}

- (BOOL)cd_boolAtIndex:(NSUInteger)index;
{
    return [self cd_boolAtIndex:index defaultValue:NO];
}

#pragma mark - Int

- (int)cd_intAtIndex:(NSUInteger)index defaultValue:(int)defaultValue;
{
    return cd_intOfValue(OAI, defaultValue);
}

- (int)cd_intAtIndex:(NSUInteger)index;
{
    return [self cd_intAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)cd_unsignedIntAtIndex:(NSUInteger)index defaultValue:(unsigned int)defaultValue;
{
    return cd_unsignedIntOfValue(OAI, defaultValue);
}

- (unsigned int)cd_unsignedIntAtIndex:(NSUInteger)index;
{
    return [self cd_unsignedIntAtIndex:index defaultValue:0];
}

#pragma mark - Long Long

- (long long int)cd_longLongAtIndex:(NSUInteger)index defaultValue:(long long int)defaultValue
{
    return cd_longLongOfValue(OAI, defaultValue);
}

- (long long int)cd_longLongAtIndex:(NSUInteger)index
{
    return [self cd_longLongAtIndex:index defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)cd_unsignedLongLongAtIndex:(NSUInteger)index defaultValue:(unsigned long long int)defaultValue;
{
    return cd_unsignedLongLongOfValue(OAI, defaultValue);
}

- (unsigned long long int)cd_unsignedLongLongAtIndex:(NSUInteger)index;
{
    return [self cd_unsignedLongLongAtIndex:index defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)cd_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;
{
    return cd_integerOfValue(OAI, defaultValue);
}

- (NSInteger)cd_integerAtIndex:(NSUInteger)index;
{
    return [self cd_integerAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)cd_unsignedIntegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue
{
    return cd_unsignedIntegerOfValue(OAI, defaultValue);
}

- (NSUInteger)cd_unsignedIntegerAtIndex:(NSUInteger)index
{
    return [self cd_unsignedIntegerAtIndex:index defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)cd_imageAtIndex:(NSUInteger)index defaultValue:(UIImage *)defaultValue
{
    return cd_imageOfValue(OAI, defaultValue);
}

- (UIImage *)cd_imageAtIndex:(NSUInteger)index
{
    return [self cd_imageAtIndex:index defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)cd_colorAtIndex:(NSUInteger)index defaultValue:(UIColor *)defaultValue
{
    return cd_colorOfValue(OAI, defaultValue);
}

- (UIColor *)cd_colorAtIndex:(NSUInteger)index
{
    return [self cd_colorAtIndex:index defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)cd_timeAtIndex:(NSUInteger)index defaultValue:(time_t)defaultValue
{
    return cd_timeOfValue(OAI, defaultValue);
}

- (time_t)cd_timeAtIndex:(NSUInteger)index
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self cd_timeAtIndex:index defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)cd_dateAtIndex:(NSUInteger)index
{
    return cd_dateOfValue(OAI);
}

#pragma mark - Enumerate

- (void)cd_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (void)cd_enumerateUnknownObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (void)cd_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(castedObj, idx, stop);
        }
    }];
}

- (void)cd_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block classes:(id)object, ...
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
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
            block(obj, idx, stop);
        }
    }];
}

- (void)cd_enumerateArrayObjectsUsingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsUsingBlock:block withCastFunction:cd_arrayOfValue];
}

- (void)cd_enumerateDictObjectsUsingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsUsingBlock:block withCastFunction:cd_dictOfValue];
}

- (void)cd_enumerateStringObjectsUsingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsUsingBlock:block withCastFunction:cd_stringOfValue];
}

- (void)cd_enumerateNumberObjectsUsingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsUsingBlock:block withCastFunction:cd_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)cd_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)cd_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateObjectsWithOptions:opts usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(castedObj, idx, stop);
        }
    }];
}

- (void)cd_enumerateArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:cd_arrayOfValue];
}

- (void)cd_enumerateDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:cd_dictOfValue];
}

- (void)cd_enumerateStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:cd_stringOfValue];
}

- (void)cd_enumerateNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
    [self cd_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:cd_numberOfValue];
}

- (NSArray *)cd_typeCastedObjectsWithCastFunction:(id (*)(id, id))castFunction
{
    NSMutableArray * result = [NSMutableArray array];
    [self cd_enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            [result addObject:obj];
        }
    } withCastFunction:castFunction];
    return result;
}

- (NSArray *)cd_stringObjects
{
    return [self cd_typeCastedObjectsWithCastFunction:cd_stringOfValue];
}
@end
