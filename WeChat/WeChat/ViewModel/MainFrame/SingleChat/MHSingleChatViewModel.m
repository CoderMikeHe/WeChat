//
//  MHSingleChatViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSingleChatViewModel.h"

@interface MHSingleChatViewModel ()

/// toUser 聊天对象
@property (nonatomic, readwrite, strong) MHUser *toUser;
/// 点击导航栏更多按钮
@property (nonatomic, readwrite, strong) RACCommand *moreCommand;

@end


@implementation MHSingleChatViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.toUser = params[MHViewModelUtilKey];
        
        self.title = self.toUser.screenName;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.moreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    NSLog(@"xxxxxxxxxxxxxx🔥");
    
    return [RACSignal empty];
}
@end
