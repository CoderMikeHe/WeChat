//
//  MHTabBar.m
//  WeChat
//
//  Created by senba on 2017/9/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTabBar.h"
@interface MHTabBar ()
/// divider
@property (nonatomic, readwrite, weak) UIView *divider ;
@end
@implementation MHTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 去掉tabBar的分割线,以及背景图片
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage mh_resizableImage:@"tabbarBkg_5x49"]];
        
        /// 添加细线,
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = MHColorFromHexString(@"#d5d5d5");
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.divider];
    self.divider.mh_height = MHGlobalBottomLineHeight;
    self.divider.mh_width = MH_SCREEN_WIDTH;
}
@end
