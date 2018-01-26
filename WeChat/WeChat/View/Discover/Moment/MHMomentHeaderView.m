//
//  MHMomentHeaderView.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信朋友圈正文

#import "MHMomentHeaderView.h"
#import "MHMomentPhotosView.h"
#import "MHMomentShareInfoView.h"
#import "MHMomentItemViewModel.h"
#import "MHMomentOperationMoreView.h"
#import "MHMenuController.h"
@interface MHMomentHeaderView ()
/// 头像
@property (nonatomic, readwrite, weak) UIImageView *avatarView;
/// 昵称
@property (nonatomic, readwrite, weak) YYLabel *screenNameLable;
/// 正文
@property (nonatomic, readwrite, weak) YYLabel *contentLable;
/// 时间
@property (nonatomic, readwrite, weak) YYLabel *createAtLable;
/// 位置
@property (nonatomic, readwrite, weak) YYLabel *locationLable;
/// 来源
@property (nonatomic, readwrite, weak) YYLabel *sourceLable;
/// 更多按钮
@property (nonatomic, readwrite, weak) UIButton *operationMoreBtn;
/// 全文/收起 按钮
@property (nonatomic, readwrite, weak) UIButton *expandBtn;
/// 配图View
@property (nonatomic, readwrite, weak) MHMomentPhotosView *photosView;
/// 分享View
@property (nonatomic, readwrite, weak) MHMomentShareInfoView *shareInfoView;
/// upArrow
@property (nonatomic, readwrite, weak) UIImageView *upArrowView;
/// 更多操作view
@property (nonatomic, readwrite, weak) MHMomentOperationMoreView *operationMoreView;
/// viewModel
@property (nonatomic, readwrite, strong) MHMomentItemViewModel *viewModel;

/*!
 @property
 @brief 菜单
 */
@property (nonatomic , readwrite , strong) MHMenuController *menuController;
@end


@implementation MHMomentHeaderView
/// init
+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MomentHeader";
    MHMomentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 初始化所有的子控件
        [self _setupSubViews];
        
        // 所有事件处理（PS：为了将UI和事件隔离）
        [self _dealWithAction];
    }
    return self;
}


#pragma mark - 公共方法
- (void)bindViewModel:(MHMomentItemViewModel *)viewModel{
    self.viewModel = viewModel;
    /// 头像
    self.avatarView.frame = viewModel.avatarViewFrame;
    [self.avatarView yy_setImageWithURL:viewModel.moment.user.profileImageUrl placeholder:MHDefaultAvatar(MHDefaultAvatarTypeDefualt) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    /// 昵称
    self.screenNameLable.textLayout = viewModel.screenNameLableLayout;
    self.screenNameLable.frame = viewModel.screenNameLableFrame;
    
    /// 正文
    self.contentLable.textLayout = viewModel.contentLableLayout;
    self.contentLable.frame = viewModel.contentLableFrame;
    
    /// 全文/收起
    self.expandBtn.frame = viewModel.expandBtnFrame;
    [self.expandBtn setTitle:viewModel.isExpand?@"收起":@"全文" forState:UIControlStateNormal];
    
    /// 配图
    self.photosView.frame = viewModel.photosViewFrame;
    [self.photosView bindViewModel:viewModel];
    
    /// 位置
    self.locationLable.textLayout = viewModel.locationLableLayout;
    self.locationLable.frame = viewModel.locationLableFrame;
    
    
    /// 时间
    self.createAtLable.textLayout = viewModel.createAtLableLayout;
    self.createAtLable.frame = viewModel.createAtLableFrame;
    
    /// 来源
    self.sourceLable.textLayout = viewModel.sourceLableLayout;
    self.sourceLable.frame = viewModel.sourceLableFrame;
    
    
    /// 更多操作按钮
    self.operationMoreBtn.frame = viewModel.operationMoreBtnFrame;
    
    /// 更多View
    self.operationMoreView.right = self.operationMoreBtn.mh_x - MHMomentContentInnerMargin;
    self.operationMoreView.mh_centerY = self.operationMoreBtn.mh_centerY;
    self.operationMoreView.mh_width = 0;
    [self.operationMoreView bindViewModel:viewModel];
    
    /// 箭头
    self.upArrowView.frame = viewModel.upArrowViewFrame;
}


#pragma mark - 私有方法
- (void)_dealWithAction{
    /// 该界面的所有事件监听
    /// 全文/收起 事件监听
    @weakify(self);
    [[self.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         /// 更新子控件的frame
         [self.viewModel.expandOperationCmd execute:@(self.section)];
     }];
    
    /// 更多按钮点击
    [[self.operationMoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         /// 这里实现判断 键盘是否已经抬起
         if (MHSharedAppDelegate.isShowKeyboard) {
             [MHSharedAppDelegate.window endEditing:YES]; /// 关掉键盘
         }else{
             /// 固定位置
             self.operationMoreView.right = self.operationMoreBtn.mh_x - MHMomentContentInnerMargin;
             self.operationMoreView.isShow?[self.operationMoreView hideWithAnimated:YES]:[self.operationMoreView showWithAnimated:YES];
             [self layoutIfNeeded];
         }
         
     }];
    
    /// 更多View的各项操作
    /// 点赞
    self.operationMoreView.attitudesClickedCallback = ^(MHMomentOperationMoreView *operationMoreView) {
        @strongify(self);
        /// 执行点赞
        [self.viewModel.attitudeOperationCmd execute:@(self.section)];
    };
    
    /// 评论
    self.operationMoreView.commentClickedCallback = ^(MHMomentOperationMoreView *operationMoreView) {
        @strongify(self);
        [self.viewModel.commentSubject sendNext:@(self.section)];
    };

    ///
   
}




/// 以下UI部分 不必过多关注
#pragma mark - 初始化
- (void)_setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    //// PS:这里把所有可能要显示的View全部初始化好，避免滚动过程中的动态创建，影响性能
    
    /// 用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.backgroundColor = self.contentView.backgroundColor;
    /// 设置可交互
    avatarView.userInteractionEnabled = YES;
    self.avatarView = avatarView;
    [self.contentView addSubview:avatarView];
    
    
    /// 昵称
    YYLabel *screenNameLable = [[YYLabel alloc] init];
    screenNameLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向中心对齐
    screenNameLable.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    /// 异步渲染和布局
    screenNameLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    screenNameLable.ignoreCommonProperties = YES;
    screenNameLable.fadeOnAsynchronouslyDisplay = NO;
    screenNameLable.fadeOnHighlight = NO;
    [self.contentView addSubview:screenNameLable];
    self.screenNameLable = screenNameLable;
    
    
    /// 正文
    YYLabel *contentLable = [[YYLabel alloc] init];
    contentLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向顶部对齐
    contentLable.textVerticalAlignment = YYTextVerticalAlignmentTop;
    /// 异步渲染和布局
    contentLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    contentLable.ignoreCommonProperties = YES;
    contentLable.fadeOnAsynchronouslyDisplay = NO;
    contentLable.fadeOnHighlight = NO;
    contentLable.preferredMaxLayoutWidth = MHMomentCommentViewWidth();
    [self.contentView addSubview:contentLable];
    self.contentLable = contentLable;
    
    /// photosView
    MHMomentPhotosView *photosView = [[MHMomentPhotosView alloc] init];
    photosView.clipsToBounds = YES;
    photosView.backgroundColor = self.contentView.backgroundColor;
    self.photosView = photosView;
    [self.contentView addSubview:photosView];
    
    /// shareInfoView
    MHMomentShareInfoView *shareInfoView = [[MHMomentShareInfoView alloc] init];
    shareInfoView.backgroundColor = MHColorFromHexString(@"#F3F3F5");
    self.shareInfoView = shareInfoView;
    [self.contentView addSubview:shareInfoView];
    
    /// 位置
    YYLabel *locationLable = [[YYLabel alloc] init];
    locationLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向中心对齐
    locationLable.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    /// 异步渲染和布局
    locationLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    locationLable.ignoreCommonProperties = NO;
    locationLable.fadeOnAsynchronouslyDisplay = NO;
    locationLable.fadeOnHighlight = NO;
    [self.contentView addSubview:locationLable];
    self.locationLable = locationLable;
    
    /// 创建时间
    YYLabel *createAtLable = [[YYLabel alloc] init];
    createAtLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向中心对齐
    createAtLable.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    /// 异步渲染和布局
    createAtLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    createAtLable.ignoreCommonProperties = YES;
    createAtLable.fadeOnAsynchronouslyDisplay = NO;
    createAtLable.fadeOnHighlight = NO;
    [self.contentView addSubview:createAtLable];
    self.createAtLable = createAtLable;
    
    /// 来源
    YYLabel *sourceLable = [[YYLabel alloc] init];
    sourceLable.backgroundColor = self.contentView.backgroundColor;
    /// 垂直方向中心对齐
    sourceLable.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    /// 异步渲染和布局
    sourceLable.displaysAsynchronously = NO;
    /// 利用textLayout来设置text、font、textColor...
    sourceLable.ignoreCommonProperties = YES;
    sourceLable.fadeOnAsynchronouslyDisplay = NO;
    sourceLable.fadeOnHighlight = NO;
    [self.contentView addSubview:sourceLable];
    self.sourceLable = sourceLable;
    
    
    /// 更多操作按钮
    UIButton *operationMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationMoreBtn setImage:MHImageNamed(@"wx_albumOperateMore_25x25") forState:UIControlStateNormal];
    [operationMoreBtn setImage:MHImageNamed(@"wx_albumOperateMoreHL_25x25") forState:UIControlStateHighlighted];
    [self.contentView addSubview:operationMoreBtn];
    operationMoreBtn.backgroundColor = self.contentView.backgroundColor;
    self.operationMoreBtn = operationMoreBtn;
    
    
    /// 展开、关闭按钮
    UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [expandBtn setTitle:@"全文" forState:UIControlStateNormal];
    [expandBtn setTitleColor:MHMomentScreenNameTextColor forState:UIControlStateNormal];
    [expandBtn.titleLabel setFont:MHMomentExpandTextFont];
    [expandBtn setBackgroundImage:[UIImage yy_imageWithColor:MHMomentTextHighlightBackgroundColor size:CGSizeMake(MHMomentExpandButtonWidth, MHMomentExpandButtonHeight)] forState:UIControlStateHighlighted];
    /// 子控件超出部分裁剪
    expandBtn.clipsToBounds = YES;
    [self.contentView addSubview:expandBtn];
    self.expandBtn = expandBtn;
    
    /// 向上的箭头
    UIImageView *upArrowView = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumTriangleB_45x6")];
    self.upArrowView = upArrowView;
    [self.contentView addSubview:upArrowView];
    
    /// 更多操作
    MHMomentOperationMoreView *operationMoreView = [[MHMomentOperationMoreView alloc] init];
    [self.contentView addSubview:operationMoreView];
    self.operationMoreView = operationMoreView;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MHLogFunc;
    [super touchesBegan:touches withEvent:event];
}

@end
