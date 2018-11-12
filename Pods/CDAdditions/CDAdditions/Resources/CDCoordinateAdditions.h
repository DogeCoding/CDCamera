//
//  CDCoordinateAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/5.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#ifndef CDCoordinateAdditions_h
#define CDCoordinateAdditions_h

// 获取中心点
CG_INLINE CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale) {
    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
}

// 获取两点距离
CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2) {
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

// 获取两点夹角
CG_INLINE CGFloat CGPointGetAngle(CGPoint point1, CGPoint point2) {
    return atan2(point1.y-point2.y,point1.x-point2.x);
}

// 获取旋转角度
CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t) {
    return atan2(t.b, t.a);
}

// 获取放大倍数
CG_INLINE CGSize CGAffineTransformGetScale(CGAffineTransform t) {
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d)) ;
}

// 通过放大倍数和旋转角度获取transform
CG_INLINE CGAffineTransform CGAffineTransformByScaleAndAngle(CGFloat scale, CGFloat angle) {
    CGAffineTransform transform_ = CGAffineTransformMakeScale(scale, scale);
    transform_ = CGAffineTransformRotate(transform_, angle);
    return transform_;
}

#endif /* CDCoordinateAdditions_h */
