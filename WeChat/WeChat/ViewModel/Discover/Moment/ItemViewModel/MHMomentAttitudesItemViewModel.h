//
//  MHMomentAttitudesItemViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  点赞列表 视图模型

#import "MHMomentContentItemViewModel.h"
#import "MHMoments.h"
@interface MHMomentAttitudesItemViewModel : MHMomentContentItemViewModel

/// 单条说说
@property (nonatomic, readonly, strong) MHMoment *moment;

/// init
- (instancetype)initWithMoment:(MHMoment *)moment;

/// 执行更新数据的命令
@property (nonatomic, readonly, strong) RACCommand *operationCmd;
@end
