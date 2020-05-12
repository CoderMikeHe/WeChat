//
//  MHSearchOfficialAccountsViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/8.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchOfficialAccountsViewModel.h"
#import "MHWebViewModel.h"
#import "MHSearchOfficialAccountsDefaultItemViewModel.h"
@interface MHSearchOfficialAccountsViewModel ()

/// officialAccountTapCommand
@property (nonatomic, readwrite, strong) RACCommand *officialAccountTapCommand;
@end

@implementation MHSearchOfficialAccountsViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.officialAccountTapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        NSString *urlStr = input.integerValue == 0 ? @"https://pvp.qq.com/" : MHMyBlogHomepageUrl;
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    [[RACObserve(self, keyword) distinctUntilChanged] subscribeNext:^(NSString * keyword) {
        @strongify(self);
        NSLog(@"公众号监听到关键字变化 👉 %@", keyword);
    }];
    
    
    /// 默认场景下
    MHSearchOfficialAccountsDefaultItemViewModel *defaultItemViewModel = [[MHSearchOfficialAccountsDefaultItemViewModel alloc] init];
    defaultItemViewModel.officialAccountTapCommand = self.officialAccountTapCommand;
    self.dataSource = @[defaultItemViewModel];
    
}

@end
