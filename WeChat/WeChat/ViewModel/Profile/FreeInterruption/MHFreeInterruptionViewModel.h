//
//  MHFreeInterruptionViewModel.h
//  WeChat
//
//  Created by senba on 2017/12/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHFreeInterruptionItemViewModel.h"
@interface MHFreeInterruptionViewModel : MHTableViewModel
/// footer
@property (nonatomic, readonly, copy) NSString *footer;
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// 完成命令
@property (nonatomic, readonly, strong) RACCommand *completeCommand;
@end
