//
//  MHFeatureSignatureTextView.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHFeatureSignatureTextView.h"

@interface MHFeatureSignatureTextView ()
/// UITextView
@property (nonatomic, readwrite, weak) UITextView *textView;

/// 分割线
@property (nonatomic, readwrite, weak) UIImageView *divider0;
/// 分割线2
@property (nonatomic, readwrite, weak) UIImageView *divider1;
/// 数字
@property (nonatomic, readwrite, weak) UILabel *wordsLabel;
@end

@implementation MHFeatureSignatureTextView

+ (instancetype)featureSignatureTextView{
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
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化
- (void)_setup{
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 初始化子空间
- (void)_setupSubViews
{
    /// UITextView
    UITextView *textView = [[UITextView alloc] init];
    textView.font = MHRegularFont_17;
    textView.textContainerInset = UIEdgeInsetsMake(14, 16, 22, 16+5);
    self.textView = textView;
    [self addSubview:textView];
    
    // 分割线
    UIImageView *divider0 = [[UIImageView alloc] init];
    self.divider0 = divider0;
    [self addSubview:divider0];
    UIImageView *divider1 = [[UIImageView alloc] init];
    self.divider1 = divider1;
    [self addSubview:divider1];
    divider0.backgroundColor = divider1.backgroundColor = MH_MAIN_LINE_COLOR_1;
    
    
    /// 数字number
    UILabel *wordsLabel = [[UILabel alloc] init];
    wordsLabel.textColor = MH_MAIN_TEXT_COLOR_1;
    wordsLabel.font = MHRegularFont_12;
    wordsLabel.text = @"30";
    wordsLabel.textAlignment = NSTextAlignmentRight;
    wordsLabel.backgroundColor = self.backgroundColor;
    self.wordsLabel = wordsLabel;
    [self addSubview:wordsLabel];
    
    /// 限制文字个数
    [textView mh_limitMaxLength:MHFeatureSignatureMaxWords];
    /// 监听数据变化
    @weakify(self);
    [[RACSignal merge:@[RACObserve(textView, text),textView.rac_textSignal]] subscribeNext:^(NSString * text) {
        @strongify(self);
        self.wordsLabel.text = [NSString stringWithFormat:@"%zd",MHFeatureSignatureMaxWords-text.length];
    }];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.divider0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    [self.divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    [self.wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-16);
        make.bottom.equalTo(self).with.offset(-9);
    }];
}


@end
