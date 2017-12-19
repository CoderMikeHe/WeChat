//
//  MHAboutUsViewController.m
//  WeChat
//
//  Created by senba on 2017/12/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAboutUsViewController.h"
#import "MHAboutUsHeaderView.h"

@interface MHAboutUsViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHAboutUsViewModel *viewModel;
@end

@implementation MHAboutUsViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}


#pragma mark - 初始化
- (void)_setup{
    

}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    @weakify(self);
    
    /// 设置header
    self.tableView.tableHeaderView = [MHAboutUsHeaderView mh_viewFromXib];
    self.tableView.tableHeaderView.mh_height = 115;
    
    /// 添加富文本
    YYLabel *copyrightLabel = [[YYLabel alloc] init];
    copyrightLabel.numberOfLines = 0;
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"《微信软件许可及服务协议》和《微信隐私保护指引》\n\n腾讯公司 版权所有\nCopyRight©2011-2017 Tencent.All Rights Reserved."];
    attributedText.yy_font = MHRegularFont_14;
    attributedText.yy_color = MHColorFromHexString(@"#888888");
    attributedText.yy_alignment = NSTextAlignmentCenter;
    
    
    /// 设置区域里面的文字
    YYTextHighlight *highlight1 = [YYTextHighlight highlightWithBackgroundColor:MHColorFromHexString(@"#BFBFC3")];
    NSRange range1 = NSMakeRange(0, 13);
    [attributedText yy_setColor:MHColorFromHexString(@"#5B6A92") range:range1];
    highlight1.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        [self.viewModel.softLicenseCommand execute:nil];
    };
    [attributedText yy_setTextHighlight:highlight1 range:range1];

    YYTextHighlight *highlight2 = [YYTextHighlight highlightWithBackgroundColor:MHColorFromHexString(@"#BFBFC3")];
    NSRange range2 = NSMakeRange(14, 10);
    [attributedText yy_setColor:MHColorFromHexString(@"#5B6A92") range:range2];
    highlight2.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        [self.viewModel.privateGuardCommand execute:nil];
    };
    [attributedText yy_setTextHighlight:highlight2 range:range2];
    copyrightLabel.attributedText = attributedText.copy;
    
    /// 设置高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(MH_SCREEN_WIDTH, MAXFLOAT)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    
    copyrightLabel.mh_y = MH_SCREEN_HEIGHT - layout.textBoundingSize.height - MH_APPLICATION_TOP_BAR_HEIGHT - 13;
    copyrightLabel.mh_width = MH_SCREEN_WIDTH ;
    copyrightLabel.mh_height = layout.textBoundingSize.height;
    [self.tableView addSubview:copyrightLabel];
}



@end
