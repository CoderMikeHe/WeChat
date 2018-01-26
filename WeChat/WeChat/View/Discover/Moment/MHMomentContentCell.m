//
//  MHMomentContentCell.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentContentCell.h"

@interface MHMomentContentCell ()
/// 正文
@property (nonatomic, readwrite, weak) YYLabel *contentLable;

@property (nonatomic , readwrite , strong) MHMomentContentItemViewModel *viewModel;
@end

@implementation MHMomentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MomentContentCell";
    MHMomentContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];

    }
    return self;
}

#pragma mark - BindViewModel 子类重写
- (void)bindViewModel:(MHMomentContentItemViewModel *)viewModel
{
    self.viewModel = viewModel;
    /// 文本
    self.contentLable.textLayout = viewModel.contentLableLayout;
    self.contentLable.frame = viewModel.contentLableFrame;
    
    self.selectionStyle = (viewModel.type == MHMomentContentTypeComment)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
    self.divider.hidden = viewModel.type == MHMomentContentTypeComment;
}

#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.contentView.backgroundColor = MHMomentCommentViewBackgroundColor;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    /// 点击选中的颜色
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = MHMomentCommentViewSelectedBackgroundColor;
    self.selectedBackgroundView = selectedView;
    
    
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
    contentLable.preferredMaxLayoutWidth = MHMomentCommentViewWidth()-2*MHMomentCommentViewContentLeftOrRightInset;
    [self.contentView addSubview:contentLable];
    self.contentLable = contentLable;
    
    /// 分割线 
    UIImageView *divider = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumCommentHorizontalLine_33x1")];
    divider.backgroundColor = WXGlobalBottomLineColor;
    self.divider = divider;
    [self.contentView addSubview:divider];
    
    

    contentLable.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"高亮点击label事件");
        
    };
    
    
    contentLable.highlightLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"高亮长按label事件");
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /// 这里的点击事件 由自己处理
    /// 先记录
    BOOL showKeyboard = MHSharedAppDelegate.isShowKeyboard;
    /// 然后设置
    MHSharedAppDelegate.showKeyboard = NO;
    [super touchesBegan:touches withEvent:event];
    MHSharedAppDelegate.showKeyboard = showKeyboard;
}

#pragma mark - Override
/// PS:重写cell的尺寸 这是评论View关键
- (void)setFrame:(CGRect)frame{
    frame.origin.x = MHMomentContentLeftOrRightInset+MHMomentAvatarWH+MHMomentContentInnerMargin;
    frame.size.width = MHMomentCommentViewWidth();
    [super setFrame:frame];
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    self.divider.frame =CGRectMake(0, self.mh_height-WXGlobalBottomLineHeight, self.mh_width, WXGlobalBottomLineHeight);
}



@end
