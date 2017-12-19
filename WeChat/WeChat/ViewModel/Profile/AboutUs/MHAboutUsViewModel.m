//
//  MHAboutUsViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAboutUsViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHWebViewModel.h"
@interface MHAboutUsViewModel ()
/// 软件许可
@property (nonatomic, readwrite, strong) RACCommand *softLicenseCommand;
/// 隐私保护
@property (nonatomic, readwrite, strong) RACCommand *privateGuardCommand;
@end

@implementation MHAboutUsViewModel

- (void)initialize{
    [super initialize];
    @weakify(self);
    
    /// 统一操作
    void (^operation)(void) = ^{
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
    };
    
    
    /// 第三组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 去评分
    MHCommonArrowItemViewModel * score = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"去评分"];
    score.operation = operation;
    /// 功能介绍
    MHCommonArrowItemViewModel * functionIntroduce = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"功能介绍"];
    functionIntroduce.operation = operation;
    /// 投诉
    MHCommonArrowItemViewModel * complain = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"投诉"];
    complain.operation = operation;
    group0.itemViewModels = @[score , functionIntroduce , complain];
    
    self.dataSource = @[group0];
    
    
    /// 初始化一些命令
    self.softLicenseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.privateGuardCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

@end
