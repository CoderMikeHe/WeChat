//
//  MHMomentCommentToolView.m
//  WeChat
//
//  Created by senba on 2018/1/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHMomentCommentToolView.h"
#import "MHMomentReplyItemViewModel.h"


@interface MHMomentCommentToolView () <YYTextViewDelegate>
/// topLine
@property (nonatomic, readwrite, weak) UIView *topLine;
/// bottomLine
@property (nonatomic, readwrite, weak) UIView *bottomLine;
/// emoticonBtn
@property (nonatomic, readwrite, weak) UIButton *emoticonBtn;
/// textView
@property (nonatomic, readwrite, weak) YYTextView *textView;
/** 记录之前编辑框的高度 */
@property (nonatomic, readwrite, assign) CGFloat previousTextViewContentHeight;
/// toHeight (随着文字的输入，MHMomentCommentToolView 将要到达的高度)
@property (nonatomic, readwrite, assign) CGFloat toHeight;

/// viewModel
@property (nonatomic, readwrite, strong) MHMomentReplyItemViewModel *viewModel;

@end


@implementation MHMomentCommentToolView
#pragma mark - Public Method
- (BOOL)mh_canBecomeFirstResponder{ return [self.textView canBecomeFirstResponder]; }
- (BOOL)mh_becomeFirstResponder{ return [self.textView becomeFirstResponder]; }
- (BOOL)mh_canResignFirstResponder { return [self.textView canResignFirstResponder]; }
- (BOOL)mh_resignFirstResponder { return [self.textView resignFirstResponder]; }


/// 绑定数据模型
- (void)bindViewModel:(MHMomentReplyItemViewModel *)viewModel{
    self.viewModel = viewModel;
    
    /// 修改textView的placeholder
    self.textView.placeholderText = self.viewModel.isReply?[NSString stringWithFormat:@"回复%@:",self.viewModel.toUser.screenName]:@"评论";
}

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

#pragma mark - 初始化
- (void)_setup{
    self.backgroundColor = MHColorFromHexString(@"#FAFAFA");
    self.previousTextViewContentHeight = MHMomentCommentToolViewMinHeight;
}

#pragma mark - 初始化子空间
- (void)_setupSubViews{
    /// textView 以及 表情按钮 和 分割线
    YYTextView *textView = [[YYTextView alloc] init];
    textView.backgroundColor = MHColorFromHexString(@"#FCFCFC");
    textView.font = MHRegularFont_16;
    textView.textAlignment = NSTextAlignmentLeft;
    UIEdgeInsets insets = UIEdgeInsetsMake(9, 9, 6, 9);
    textView.textContainerInset = insets;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.layer.cornerRadius = 6;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = MHGlobalBottomLineColor.CGColor;
    textView.layer.borderWidth = .5;
    textView.placeholderText = @"评论";
    textView.placeholderTextColor = MHColorFromHexString(@"#AAAAAA");
    textView.delegate = self;
    self.textView = textView;
    [self addSubview:textView];
    
    /// 表情按钮
    UIButton *emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emoticonBtn setBackgroundImage:MHImageNamed(@"Album_ToolViewEmotion_30x30") forState:UIControlStateNormal];
    [emoticonBtn setBackgroundImage:MHImageNamed(@"Album_ToolViewEmotionHL_30x30") forState:UIControlStateHighlighted];
    self.emoticonBtn = emoticonBtn;
    [self addSubview:emoticonBtn];
    
    
    /// 上下两条分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = MHGlobalBottomLineColor;
    [self addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = MHGlobalBottomLineColor;
    [self addSubview:bottomLine];
    self.topLine = topLine;
    self.bottomLine = bottomLine;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局表情按钮
    [self.emoticonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.equalTo(self).with.offset(-13);
        make.width.and.height.mas_equalTo(30);
    }];
    
    
    /// 布局topLine
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    /// 布局bottomLine
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    /// 布局textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
        make.right.equalTo(self.emoticonBtn.mas_left).with.offset(-13);
    }];
}


#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    // 改变高度
    [self _commentViewWillChangeHeight:[self _getTextViewHeight:textView]];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码 （发送）
        /// 传递文本内容
        self.viewModel.text = textView.text;
        /// 传递数据
        [self.viewModel.commentCommand execute:self.viewModel];
        /// 轻空TextView
        textView.text = nil;
        /// 键盘掉下
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    return YES;
}

#pragma mark - 辅助方法
- (void)_commentViewWillChangeHeight:(CGFloat)toHeight{
    
    // 需要加上 MHMomentCommentToolViewWithNoTextViewHeight才是commentViewHeight
    toHeight = toHeight + MHMomentCommentToolViewWithNoTextViewHeight;
    /// 是否小于最小高度
    if (toHeight < MHMomentCommentToolViewMinHeight || self.textView.attributedText.length == 0){
        toHeight = MHMomentCommentToolViewMinHeight;
    }
    /// 是否大于最大高度
    if (toHeight > MHMomentCommentToolViewMaxHeight) { toHeight = MHMomentCommentToolViewMaxHeight ;}
    
    // 高度是之前的高度  跳过
    if (toHeight == self.previousTextViewContentHeight) return;
    
    /// 记录上一次的高度
    self.previousTextViewContentHeight = toHeight;
    
    /// 记录toheight 
    self.toHeight = toHeight;
}


/** 获取编辑框的高度 */
- (CGFloat)_getTextViewHeight:(YYTextView *)textView{
    return textView.textLayout.textBoundingSize.height;
}
@end
