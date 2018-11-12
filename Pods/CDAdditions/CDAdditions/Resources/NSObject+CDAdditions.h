//
//  NSObject+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/5.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CDAdditions)

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)cd_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)cd_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/*!
 *  取得当前对象对应key的关联对象
 *
 *  @param key 关联对象key
 *
 *  @return 对应key的关联对象
 */
- (id)cd_objectWithAssociatedKey:(void *)key;

/*!
 *  设置关联对象给对应key
 *
 *  @param object 关联对象
 *  @param key    关联对象对应key
 *  @param retain 是否要retain该对象
 */
- (void)cd_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retain;

/*!
 *  设置关联对象给对应key
 *
 *  @param object 关联对象
 *  @param key    关联对象对应key
 *  @param policy AssociationPolicy
 */
- (void)cd_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy;

@end

NS_ASSUME_NONNULL_END
