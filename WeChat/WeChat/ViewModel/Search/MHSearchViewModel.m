//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
#import "MHWebViewModel.h"

@interface MHSearchViewModel ()

/// searchTypeViewModel
@property (nonatomic, readwrite, strong) MHSearchTypeItemViewModel *searchTypeViewModel;

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

/// popItemSubject 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调
@property (nonatomic, readwrite, strong) RACSubject *popItemSubject;

/// officialAccountsViewModel
@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;

/// officialAccountTapCommand
@property (nonatomic, readwrite, strong) RACCommand *officialAccountTapCommand;

@end
@implementation MHSearchViewModel


- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.searchTypeSubject = [RACSubject subject];
    self.popItemSubject = [RACSubject subject];
    self.officialAccountTapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        
        NSLog(@"xxx  %@", input);
        
        NSString *urlStr = input.integerValue == 0 ? @"https://pvp.qq.com/" : MHMyBlogHomepageUrl;
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    
    // 创建viewModel
    self.searchTypeViewModel = [[MHSearchTypeItemViewModel alloc] init];
    self.searchTypeViewModel.searchTypeSubject = self.searchTypeSubject;
    
    // 公众号ViewModel
    self.officialAccountsViewModel = [[MHSearchOfficialAccountsViewModel alloc] initWithServices:self.services params:@{MHViewModelIDKey: @(MHSearchTypeOfficialAccounts), MHViewModelUtilKey: self.popItemSubject}];
    //
//    self.officialAccountsViewModel.officialAccountTapCommand = self.officialAccountTapCommand;
}


@end
