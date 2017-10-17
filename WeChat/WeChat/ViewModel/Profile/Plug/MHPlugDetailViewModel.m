//
//  MHPlugDetailViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPlugDetailViewModel.h"
#import "MHWebViewModel.h"
@interface MHPlugDetailViewModel ()
/// type
@property (nonatomic, readwrite, assign) MHPlugDetailType type;

/// feedbackCommand
@property (nonatomic, readwrite, strong) RACCommand *feedbackCommand;
@end

@implementation MHPlugDetailViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取user
        self.type = [params[MHViewModelIDKey] integerValue];
        
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.title = nil;
    /// 去掉导航栏的细线
    self.prefersNavigationBarBottomLineHidden = YES;
    
    self.feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        webViewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:webViewModel animated:YES];
        return [RACSignal empty];
    }];
}
@end
