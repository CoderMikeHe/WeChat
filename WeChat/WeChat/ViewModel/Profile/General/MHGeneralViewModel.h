//
//  MHGeneralViewModel.h
//  WeChat
//
//  Created by senba on 2017/12/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

@interface MHGeneralViewModel : MHCommonViewModel
/// 清除聊天记录de的命令
@property (nonatomic, readonly, strong) RACCommand *clearChatRecordsCommand;
@end
