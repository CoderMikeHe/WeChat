//
//  MHPlugViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPlugViewModel.h"
#import "MHPlugDetailViewModel.h"
#import "MHWebViewModel.h"
@interface MHPlugViewModel ()
/// plugDetailCommand
@property (nonatomic, readwrite, strong) RACCommand *plugDetailCommand;
/// 使用协议cmd
@property (nonatomic, readwrite, strong) RACCommand *useIntroCommand;
@end

@implementation MHPlugViewModel
- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"插件";
    /// 去掉导航栏的细线
    self.prefersNavigationBarBottomLineHidden = YES;
    
    self.useIntroCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        webViewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:webViewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.plugDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHPlugDetailViewModel *viewModel = [[MHPlugDetailViewModel alloc] initWithServices:self.services params:@{MHViewModelIDKey:input}];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}
@end
