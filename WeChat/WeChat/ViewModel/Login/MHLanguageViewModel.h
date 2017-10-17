//
//  MHLanguageViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHLanguageItemViewModel.h"
@interface MHLanguageViewModel : MHTableViewModel
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// 完成命令
@property (nonatomic, readonly, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validCompleteSignal;
/// 选中的indexPath （一进来滚动到指定的界面）
@property (nonatomic, readonly, strong) NSIndexPath *indexPath;

@end
