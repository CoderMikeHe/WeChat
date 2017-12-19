//
//  MHCommonFooterView.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonFooterView.h"
#import "MHCommonGroupViewModel.h"
@interface MHCommonFooterView ()
/// viewModel
@property (nonatomic, readwrite, strong) MHCommonGroupViewModel *viewModel;
/// contentLabel
@property (nonatomic, readwrite, weak) UILabel *contentLabel;

@end

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

- (void)bindViewModel:(MHCommonGroupViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.contentLabel.text = viewModel.footer;
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
- (void)_setup{
    ///
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    // label
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = MHColorFromHexString(@"#888888");
    contentLabel.font = MHRegularFont_14;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
}
@end
