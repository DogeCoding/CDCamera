//
//  UIButton+CDAdditions.h
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/10.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CDAdditions)

/**UIButton 垂直布局的间距，设置该值就变成垂直布局,用于Xib中keyvalue的使用*/
@property (nonatomic, assign) CGFloat verticalLayoutSpacing;

/**图片上下垂直居中*/
- (void)verticalImageAndTitle:(float)spacing;

@end

