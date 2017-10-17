//
//  MHFeatureSignatureViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"

@interface MHFeatureSignatureViewModel : MHViewModel
/// 取消的命令
@property (nonatomic, readonly, strong) RACCommand *cancelCommand;

/// text
@property (nonatomic, readwrite, strong) NSString *text;

/// completeCommand
@property (nonatomic, readonly, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validCompleteSignal;
@end
