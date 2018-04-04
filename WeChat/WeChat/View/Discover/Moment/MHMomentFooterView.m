//
//  MHMomentFooterView.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentFooterView.h"

@interface MHMomentFooterView ()
/// 分割线
@property (nonatomic, readwrite, weak) UIImageView *divider;
@end

@implementation MHMomentFooterView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MomentFooter";
    MHMomentFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footer == nil) {
        // 缓存池中没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}


#pragma mark - 公共方法

#pragma mark - Private Method
- (void)_setup
{
    /// 这里设置背景色为clearColor 目的是不要遮盖 operationMoreView .若不明白，请设置 whiteColor 验证一下即可
    self.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 分割线
    UIImageView *divider = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumCommentHorizontalLine_33x1")];
    divider.backgroundColor = WXGlobalBottomLineColor;
    self.divider = divider;
    [self.contentView addSubview:divider];
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(WXGlobalBottomLineHeight);
    }];
}

@end
