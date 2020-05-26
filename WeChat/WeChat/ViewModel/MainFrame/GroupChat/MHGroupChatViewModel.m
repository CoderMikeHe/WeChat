//
//  MHGroupChatViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHGroupChatViewModel.h"
@interface MHGroupChatViewModel ()

/// toUsers 聊天对象群
@property (nonatomic, readwrite, copy) NSArray *toUsers;
/// 点击导航栏更多按钮
@property (nonatomic, readwrite, strong) RACCommand *moreCommand;

@end
@implementation MHGroupChatViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.toUsers = params[MHViewModelUtilKey];
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
    return [RACSignal empty];
}
@end
