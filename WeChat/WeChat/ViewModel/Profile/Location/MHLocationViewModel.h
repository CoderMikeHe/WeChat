//
//  MHLocationViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

@interface MHLocationViewModel : MHTableViewModel
/// 取消的命令
@property (nonatomic, readonly, strong) RACCommand *cancelCommand;
/// completeCommand
@property (nonatomic, readonly, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validCompleteSignal;
@end
