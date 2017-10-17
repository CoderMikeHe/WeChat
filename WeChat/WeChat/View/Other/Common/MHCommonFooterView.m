//
//  MHCommonFooterView.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonFooterView.h"

@implementation MHCommonFooterView
#pragma mark - 公共方法
+ (instancetype)footerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CommonFooter";
    MHCommonFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footer == nil) {
        // 缓存池中没有, 自己创建
        footer = [[self alloc] initWithReuseIdentifier:ID];
    }
    return footer;
}

- (void)bindViewModel:(id)viewModel{
    
}

#pragma mark - 私有方法
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


#pragma mark - 初始化
- (void)_setup
{
    /// 
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    // 分割线
    //    UIImageView *divider = [[UIImageView alloc] initWithImage:MHImageNamed(@"wx_albumCommentHorizontalLine_33x1")];
    //    divider.backgroundColor = WXGlobalBottomLineColor;
    //    self.divider = divider;
    //    [self.contentView addSubview:divider];
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    //    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.bottom.and.right.equalTo(self.contentView);
    //        make.height.mas_equalTo(WXGlobalBottomLineHeight);
    //    }];
}
@end
