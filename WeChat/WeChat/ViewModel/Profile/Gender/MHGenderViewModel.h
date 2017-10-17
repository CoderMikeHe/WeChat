//
//  MHGenderViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  性别选则

#import "MHTableViewModel.h"
#import "MHGenderItemViewModel.h"

@interface MHGenderViewModel : MHTableViewModel
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// 完成命令
@property (nonatomic, readonly, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validCompleteSignal;
@end
