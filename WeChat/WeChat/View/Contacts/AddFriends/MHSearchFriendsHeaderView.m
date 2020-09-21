//
//  MHSearchFriendsHeaderView.m
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSearchFriendsHeaderView.h"
#import "MHSearchFriendsHeaderViewModel.h"
@interface MHSearchFriendsHeaderView ()
/// WeChatId
@property (weak, nonatomic) IBOutlet UILabel *weChatIdLabel;

/// 二维码
@property (weak, nonatomic) IBOutlet UIButton *qrCodeBtn;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchFriendsHeaderViewModel *viewModel;
@end


@implementation MHSearchFriendsHeaderView

+ (instancetype)headerView{
    return [self mh_viewFromXib];
}

- (void)bindViewModel:(MHSearchFriendsHeaderViewModel *)viewModel{
    self.viewModel = viewModel;
    self.weChatIdLabel.text = [NSString stringWithFormat:@"我的微信号：%@",viewModel.user.wechatId];
    [self.weChatIdLabel sizeToFit];
    [self setNeedsLayout];
}

#pragma mark - 事件处理
- (IBAction)_qrCodeBtnDidClicked:(UIButton *)sender {
    /// 点击二维码
    NSLog(@"二维码点击");
    NSLog(@"添加点击");
}

- (IBAction)_searchBtnDidClicked:(UIButton *)sender {
//    [self.viewModel.searchCommand execute:nil];
    /// 回调
    !self.searchCallback ? : self.searchCallback(self);
}
#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.weChatIdLabel.mh_width + 13 + 20;
    
    self.weChatIdLabel.mh_x = (self.mh_width - width)*.5;
    self.weChatIdLabel.mh_height = 36.0f;
    
    self.qrCodeBtn.mh_size = CGSizeMake(20, 20);
    self.qrCodeBtn.mh_x = self.weChatIdLabel.right + 13.0f;
    self.qrCodeBtn.mh_centerY = self.weChatIdLabel.mh_centerY;
}

@end
