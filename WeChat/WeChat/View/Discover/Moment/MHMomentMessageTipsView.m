//
//  MHMomentMessageTipsView.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentMessageTipsView.h"
#import "MHMomentProfileViewModel.h"
@interface MHMomentMessageTipsView ()

/// 右箭头
@property (nonatomic, readwrite, weak) UIImageView *rightArrow;

/// viewModel
@property (nonatomic, readwrite, strong) MHMomentProfileViewModel *viewModel;

@end

@implementation MHMomentMessageTipsView

+ (instancetype)messageTipsView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
    }
    return self;
}

#pragma mark - BindData
- (void)bindViewModel:(MHMomentProfileViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self yy_setImageWithURL:viewModel.unreadUser.profileImageUrl forState:UIControlStateNormal placeholder:MHDefaultAvatar(MHDefaultAvatarTypeSmall) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    
    
    
    @weakify(self);
    [[RACObserve(viewModel , unread)
      distinctUntilChanged]
     subscribeNext:^(NSNumber * unread) {
         @strongify(self);
         [self setTitle:viewModel.unreadTips forState:UIControlStateNormal];
     }];
}


#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.backgroundColor = [UIColor whiteColor];
    
    [self setBackgroundImage:[MHImageNamed(@"wx_AlbumTimeLineTipBkg_50x40") resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    [self setBackgroundImage:[MHImageNamed(@"wx_AlbumTimeLineTipBkgHL_50x40") resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateHighlighted];
    
    /// setup
    self.titleLabel.font = MHMediumFont(12.0f);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    /// 右箭头
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumTimeLineTipArrow_15x15") highlightedImage:MHImageNamed(@"wx_AlbumTimeLineTipArrowHL_15x15")];
    self.rightArrow = rightArrow;
    [self addSubview:rightArrow];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /// 布局头像
    self.imageView.mh_size = CGSizeMake(MHMomentProfileViewTipsViewAvatarWH, MHMomentProfileViewTipsViewAvatarWH);
    self.imageView.mh_x = MHMomentProfileViewTipsViewInnerInset;
    self.imageView.mh_centerY = self.mh_height * .5f;
    
    
    /// 布局右箭头
    self.rightArrow.mh_x =  self.mh_width - MHMomentProfileViewTipsViewRightInset - MHMomentProfileViewTipsViewRightArrowWH;
    self.rightArrow.mh_centerY = self.imageView.mh_centerY ;
    
    
    /// 布局文字
    self.titleLabel.mh_x = CGRectGetMaxX(self.imageView.frame)+MHMomentProfileViewTipsViewInnerInset;
    self.titleLabel.mh_width = CGRectGetMinX(self.rightArrow.frame)-self.titleLabel.mh_x-MHMomentProfileViewTipsViewInnerInset;
    self.titleLabel.mh_centerY = self.imageView.mh_centerY ;
    
}
@end
