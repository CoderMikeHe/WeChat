//
//  MHMomentProfileView.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentProfileView.h"
#import "MHMomentMessageTipsView.h"
#import "MHControl.h"
#import "MHMomentProfileViewModel.h"
@interface MHMomentProfileView ()
/// 昵称
@property (nonatomic, readwrite, weak) YYLabel *screenNameLable ;

/// 封面
@property (nonatomic, readwrite, weak) UIButton *coverBtn;

/// 头像
@property (nonatomic, readwrite, weak) MHControl *avatarView;

/// tipsView
@property (nonatomic, readwrite, weak) MHMomentMessageTipsView *tipsView;

/// 分割线
@property (nonatomic, readwrite, weak) UIImageView *divider;


/// viewModel
@property (nonatomic, readwrite, strong) MHMomentProfileViewModel *viewModel;
@end


@implementation MHMomentProfileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}


#pragma mark - BindData
- (void)bindViewModel:(MHMomentProfileViewModel *)viewModel{
    
    self.viewModel = viewModel;
    
    /// 封面
    [self.coverBtn setBackgroundImage:viewModel.user.coverImage forState:UIControlStateNormal];
    
    /// 昵称
    self.screenNameLable.attributedText = viewModel.screenNameAttr;
    
    /// 头像
    [self.avatarView.layer yy_setImageWithURL:viewModel.user.profileImageUrl placeholder:MHDefaultAvatar(MHDefaultAvatarTypeDefualt) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image && stage == YYWebImageStageFinished) self.avatarView.image = image;
    }];
    
    /// tipsView
    [self.tipsView bindViewModel:viewModel];
    
    /// 分割线
    @weakify(self);
    [[RACObserve(viewModel , unread)
     distinctUntilChanged]
     subscribeNext:^(NSNumber * unread) {
         @strongify(self);
         self.divider.hidden = unread.integerValue==0;
         self.tipsView.hidden = self.divider.hidden;
         [self layoutIfNeeded];
     }];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局封面
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self);
        make.height.equalTo(self.coverBtn.mas_width);
    }];
    
    
    /// 布局头像
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(MHMomentProfileViewAvatarViewWH);
        make.right.equalTo(self).with.offset(-MHMomentContentInnerMargin);
        make.top.equalTo(self.coverBtn.mas_bottom).with.offset(24-MHMomentProfileViewAvatarViewWH);
    }];
    
    /// 布局昵称
    /// CoderMikeHe Fixed: 这里由于布局问题，会引发不知原因的闪退
    [self.screenNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverBtn).with.offset(-MHMomentContentInnerMargin);
        make.right.equalTo(self.avatarView.mas_left).with.offset(-MHMomentContentLeftOrRightInset);
        make.left.equalTo(self.coverBtn);
    }];
    

    /// 布局tips消息按钮
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.divider.mas_top).with.offset(-14);
        make.width.mas_equalTo(MHMomentProfileViewTipsViewWidth);
        make.height.mas_equalTo(MHMomentProfileViewTipsViewHeight);
        
    }];
    
    /// 布局分割线
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(WXGlobalBottomLineHeight);
    }];
}

#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    /// 封面
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    @weakify(self);
    [[coverBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         self.viewModel.unread = 10;
     }];
    self.coverBtn = coverBtn;
    [self addSubview:coverBtn];
    
    /// 昵称
    YYLabel *screenNameLable = [[YYLabel alloc] init];
    /// 去掉交互
//    screenNameLable.userInteractionEnabled = NO;
    screenNameLable.backgroundColor = [UIColor clearColor];
//    screenNameLable.numberOfLines = 1;
    screenNameLable.textAlignment = NSTextAlignmentRight;
    /// 垂直方向中心对齐
    screenNameLable.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    /// 异步渲染和布局
    screenNameLable.displaysAsynchronously = NO;
//    /// 利用textLayout来设置text、font、textColor...
    screenNameLable.ignoreCommonProperties = NO;
    screenNameLable.fadeOnAsynchronouslyDisplay = NO;
    screenNameLable.fadeOnHighlight = NO;
    self.screenNameLable = screenNameLable;
    [coverBtn addSubview:screenNameLable];
    
    
    /// 头像
    MHControl *avatarView = [[MHControl alloc] init];
    avatarView.layer.borderWidth = WXGlobalBottomLineHeight;
    avatarView.layer.borderColor = MHColorFromHexString(@"#D4D4D4").CGColor;
    self.avatarView = avatarView;
    avatarView.touchBlock = ^(MHControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        /// 跳转到用户详情
        
        
    };
    [self addSubview:avatarView];
    
    /// tipsView
    MHMomentMessageTipsView *tipsView = [MHMomentMessageTipsView messageTipsView];
    [[tipsView rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         self.viewModel.unread = 0;
     }];
    self.tipsView = tipsView;
    [self addSubview:tipsView];
    
    
    /// 分割线 （消息未读数=0 hide）
    UIImageView *divider = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumCommentHorizontalLine_33x1")];
    divider.backgroundColor = WXGlobalBottomLineColor;
    self.divider = divider;
    [self addSubview:divider];
}

@end
