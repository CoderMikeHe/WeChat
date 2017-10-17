//
//  MHModifyNicknameViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHModifyNicknameViewModel.h"

@interface MHModifyNicknameViewModel ()
/// 取消的命令
@property (nonatomic, readwrite, strong) RACCommand *cancelCommand;
/// completeCommand
@property (nonatomic, readwrite, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validCompleteSignal;

/// nickname
@property (nonatomic, readwrite, copy) NSString *nickname;

@end

@implementation MHModifyNicknameViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取昵称
        self.nickname = params[MHViewModelUtilKey];
        self.text = self.nickname;
    }
    return self;
}

- (void)initialize{
    
    [super initialize];
    @weakify(self);
    self.title = @"设置名字";
    
    /// 去掉键盘管理
    self.keyboardEnable = NO;
    self.shouldResignOnTouchOutside = NO;
    self.validCompleteSignal = [RACObserve(self, text) map:^id(NSString *text) {
        @strongify(self);
        return @(text.length>0 && ![text isEqualToString:self.nickname]);
    }];
    
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.completeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 回调数据
        !self.callback?:self.callback(self.text);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
}
@end
