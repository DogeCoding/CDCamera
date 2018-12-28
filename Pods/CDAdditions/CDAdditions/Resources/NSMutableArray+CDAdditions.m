//
//  NSMutableArray+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "NSMutableArray+CDAdditions.h"

@implementation NSMutableArray (CDAdditions)

- (void)cd_addSafeObject:(id)obj
{
    if (obj)
    {
        [self addObject:obj];
    }
}

- (void)cd_addSafeObject:(id)objectValue placeholder:(id)placeholder
{
    id value = nil != objectValue ? objectValue : placeholder;
    [self addObject:value];
}

+ (NSMutableArray*)cd_arrayWithSet:(NSSet*)set
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[set count]];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [array addObject:obj];
    }];
    return array;
}

- (void)cd_addObjectIfAbsent:(id)object
{
    if (object == nil || [self containsObject:object])
    {
        return;
    }
    
    [self addObject:object];
}

- (NSMutableArray *)cd_reverse
{
    for (int i=0; i<(floor([self count]/2.0)); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
    return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *)cd_scramble
{
    for (int i=0; i<([self count]-2); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:(i+(random()%([self count]-i)))];
    return self;
}

- (NSMutableArray *)cd_removeFirstObject
{
    [self removeObjectAtIndex:0];
    return self;
}

- (void)cd_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if (!anObject) {
        return;
    }
    if (index >=0 && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}


@end
