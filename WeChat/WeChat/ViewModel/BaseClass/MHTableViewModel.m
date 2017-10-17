//
//  MHTableViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

@interface MHTableViewModel ()
/// request remote data cmd
@property (nonatomic, readwrite, strong) RACCommand *requestRemoteDataCommand;
@end


@implementation MHTableViewModel
- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.perPage = 20;
    
    /// request remote data
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    /// 过滤错误信息
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

/// sub class can ovrride it
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

@end
