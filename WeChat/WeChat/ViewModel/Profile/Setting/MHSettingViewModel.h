//
//  MHSettingViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

@interface MHSettingViewModel : MHCommonViewModel
/// 登出的命令
@property (nonatomic, readonly, strong) RACCommand *logoutCommand;

/// 登出回调
@property (nonatomic, readonly, strong) RACSubject *logoutSubject;
@end
