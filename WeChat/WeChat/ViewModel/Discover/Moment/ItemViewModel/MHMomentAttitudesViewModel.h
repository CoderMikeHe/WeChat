//
//  MHMomentAttitudesViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  点赞

#import "MHMomentContentViewModel.h"
#import "MHMoments.h"
@interface MHMomentAttitudesViewModel : MHMomentContentViewModel

/// 单条说说
@property (nonatomic, readonly, strong) MHMoment *moment;

/// init
- (instancetype)initWithMoment:(MHMoment *)moment;

/// 执行更新数据的命令
@property (nonatomic, readonly, strong) RACCommand *operationCmd;
@end
