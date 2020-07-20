//
//  MHPulldownAppletViewModel.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletViewModel.h"
#import "MHPulldownAppletItemViewModel.h"
#import "MHWebViewModel.h"
#import "MHAppletViewModel.h"
@interface MHPulldownAppletViewModel ()
/// 点击事件
@property (nonatomic, readwrite, strong) RACCommand *didTapItemCommand;

@end


@implementation MHPulldownAppletViewModel


- (void)initialize {
    [super initialize];
    
    /// 配置数据源
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    
    @weakify(self);
    
    self.didTapItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *homepage) {
        @strongify(self);
        if (MHStringIsNotEmpty(homepage)) {
            NSURL *url = [NSURL URLWithString:homepage];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            viewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:viewModel animated:YES];
        } else {
            /// 更多模块
            MHAppletViewModel *viewModel = [[MHAppletViewModel alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:viewModel animated:YES];
        }
        /// 先跳转过去 在回到主页
        !self.callback ? : self.callback(@{@"completed":@YES,@"delay":@YES});
        return [RACSignal empty];
    }];
    
    
    /// 配置测试数据
    MHPulldownAppletItemViewModel *itemViewModel0 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"glory_of_kings" title:@"王者荣耀" homepage:MHPVPHomepageUrl];
    itemViewModel0.didTapItemCommand = self.didTapItemCommand;
    
    MHPulldownAppletItemViewModel *itemViewModel1 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"peace_elite" title:@"和平精英" homepage:MHGPHomepageUrl];
    itemViewModel1.didTapItemCommand = self.didTapItemCommand;
    
    MHPulldownAppletItemViewModel *itemViewModel2 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"tencent_sports" title:@"腾讯体育+" homepage:MHSportsHomepageUrl];
    itemViewModel2.didTapItemCommand = self.didTapItemCommand;
    
    MHPulldownAppletItemViewModel *itemViewModel3 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"WAMainFrame_More_50x50" title:@""];
    itemViewModel3.didTapItemCommand = self.didTapItemCommand;
    
    /// 配置数据源
    self.dataSource = @[@[itemViewModel0,itemViewModel1,itemViewModel2,itemViewModel3], @[itemViewModel2,itemViewModel1,itemViewModel0]];
}

@end
