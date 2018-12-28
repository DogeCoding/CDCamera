//
//  UIButton+CDAdditions.m
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/12/10.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

#import "UIButton+CDAdditions.h"
#import "CDConstant.h"

@implementation UIButton (CDAdditions)

- (void)setVerticalLayoutSpacing:(CGFloat)verticalLayoutSpacing
{
    [self verticalImageAndTitle:verticalLayoutSpacing];
}
/**填空，无实际意义*/
- (CGFloat)verticalLayoutSpacing
{
    return 0.0;
}


- (void)verticalImageAndTitle:(float)spacing
{
    dispatch_main_async(^{
        // lower the text and push it left so it appears centered
        //  below the image
        CGSize imageSize = self.imageView.image.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(
                                                0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
        self.imageEdgeInsets = UIEdgeInsetsMake(
                                                - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
        
        // increase the content height to avoid clipping
        CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    });
}

@end
