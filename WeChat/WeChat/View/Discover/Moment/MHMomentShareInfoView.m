//
//  MHMomentShareInfoView.m
//  WeChat
//
//  Created by senba on 2018/2/1.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  用户分享的内容

#import "MHMomentShareInfoView.h"
#import "MHMomentItemViewModel.h"

@interface MHMomentShareInfoView ()
/// viewModel
@property (nonatomic, readwrite, strong) MHMomentItemViewModel *viewModel;
/// avatarView
@property (weak, readwrite, nonatomic)  UIImageView *avatarView;
/// playBtn
@property (weak, readwrite, nonatomic)  UIButton *playBtn;
/// titleLabel
@property (weak, readwrite, nonatomic)  UILabel *titleLabel;
/// detailLabel
@property (weak, readwrite, nonatomic)  UILabel *detailLabel;
@end


@implementation MHMomentShareInfoView

/// bind data
- (void)bindViewModel:(MHMomentItemViewModel *)viewModel{
    self.viewModel = viewModel;
    [self.avatarView yy_setImageWithURL:viewModel.moment.shareInfo.thumbImage placeholder:MHWebImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    self.titleLabel.text = viewModel.moment.shareInfo.title;
    self.detailLabel.text = viewModel.moment.shareInfo.descr;
    
    // 更新一下布局
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat margin = MHStringIsNotEmpty(viewModel.moment.shareInfo.descr)? -15 : 0;
        make.bottom.equalTo(self.avatarView.mas_bottom).with.offset(margin);
    }];
    
    self.playBtn.hidden = (viewModel.moment.shareInfo.shareInfoType != MHMomentShareInfoTypeMusic);
}

+ (instancetype)shareInfoView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self setup];
        
        // 创建自控制器
        [self setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化
- (void)setup{
    [super setup];
    
    self.backgroundColor = MHMomentCommentViewBackgroundColor;
}

#pragma mark - 初始化子空间
- (void)setupSubViews{
    [super setupSubViews];
    
    /// avatarView
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.userInteractionEnabled = YES;
    self.avatarView = avatarView;
    [self addSubview:avatarView];
    
    /// titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = MHRegularFont_13;
    self.titleLabel  = titleLabel;
    [self addSubview:titleLabel];
    
    /// detailLabel
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = MHColorFromHexString(@"737373");
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = MHRegularFont_12;
    self.detailLabel  = detailLabel;
    [self addSubview:detailLabel];
    
    /// 播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:MHImageNamed(@"GiftVideoPlayIcon_23x23") forState:UIControlStateNormal];
    self.playBtn = playBtn;
    [avatarView addSubview:playBtn];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.lessThanOrEqualTo(self).with.offset(5);
        make.bottom.lessThanOrEqualTo(self).with.offset(-5);
        make.width.mas_lessThanOrEqualTo(40);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top);
        make.bottom.equalTo(self.avatarView.mas_bottom);
        make.left.lessThanOrEqualTo(self.avatarView.mas_right).with.offset(5);
        make.right.greaterThanOrEqualTo(self).with.offset(-5);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarView.mas_bottom);
        make.left.equalTo(self.avatarView.mas_right).with.offset(5);
        make.right.equalTo(self).with.offset(-5);
    }];
}

@end
