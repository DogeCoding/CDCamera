//
//  NSMutableArray+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/28.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (CDAdditions)

/*!
 *  向数组中添加对象；如果该对象为nil，则不添加。
 *
 *  @param obj 要添加的对象
 */
- (void)cd_addSafeObject:(id)obj;

/*!
 *  向数组中添加对象；如果该对象为nil，则用placeholder占位。
 *
 *  @param objectValue 要添加的对象
 *
 *  @param placeholder 占位对象
 */
- (void)cd_addSafeObject:(id)objectValue placeholder:(id)placeholder;

/*!
 *  用传入的NSSet参数，生成一个NSMutableArray
 *
 *  @param set 参数set
 *
 *  @return 转换后的NSMutableArray
 */
+ (NSMutableArray*)cd_arrayWithSet:(NSSet*)set;

/*!
 *  向数组中添加对象；如果该对象已经在数组中，或者为nil则不添加。
 *
 *  @param object 要添加的对象
 */
- (void)cd_addObjectIfAbsent:(id)object;

/*!
 *  删除当前数组中的第一个对象，并返回当前数组。
 *
 *  @return 返回删除第一个对象后的数组
 */
- (NSMutableArray *)cd_removeFirstObject;

/*!
 *  将当前数组内的对象反序排列，并返回反序后的当前数组对象。
 *
 *  @return 返回反序排列后的当前数组
 */
- (NSMutableArray *)cd_reverse;

/*!
 *  随机调整当前数组内元素的排列顺序，并返回调整顺序后的当前数组对象。
 *
 *  @return 调整顺序后的当前数组
 */
- (NSMutableArray *)cd_scramble;

/*!
 *  在指定位置替换数组中的对象。
 *  @param index      :数组中被替换原素的位置
 *  @param anObject   :将要替换成的新元素
 */
- (void)cd_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;

@property (readonly, getter=cd_reverse) NSMutableArray *cd_reversed;


@end
