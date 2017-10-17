//
//  MHLocationViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLocationViewModel.h"

@interface MHLocationViewModel ()
/// 取消的命令
@property (nonatomic, readwrite, strong) RACCommand *cancelCommand;
/// completeCommand
@property (nonatomic, readwrite, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validCompleteSignal;
@end

@implementation MHLocationViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取昵称

    }
    return self;
}

- (void)initialize{
    
    [super initialize];
    @weakify(self);
    self.title = @"设置地区";
    
    /// 去掉键盘管理
//    self.validCompleteSignal = [RACObserve(self, text) map:^id(NSString *text) {
//        @strongify(self);
//        return @(text.length>0 && ![text isEqualToString:self.nickname]);
//    }];
    
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.completeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 回调数据
//        !self.callback?:self.callback(self.text);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
}
@end
