//
//  MHPlugViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  插件ViewModel

#import "MHViewModel.h"

@interface MHPlugViewModel : MHViewModel
/// plugDetailCommand
@property (nonatomic, readonly, strong) RACCommand *plugDetailCommand;
/// 使用协议cmd
@property (nonatomic, readonly, strong) RACCommand *useIntroCommand;
@end
