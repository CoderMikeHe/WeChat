//
//  MHMomentViewModel.h
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHMomentItemViewModel.h"
#import "MHMomentAttitudesItemViewModel.h"
#import "MHMomentCommentItemViewModel.h"
#import "MHMomentProfileViewModel.h"
#import "MHMomentReplyItemViewModel.h"
@interface MHMomentViewModel : MHTableViewModel
/// 个人信息头部视图模型
@property (nonatomic, readonly, strong) MHMomentProfileViewModel *profileViewModel;
/// 刷新某一个section的 事件回调
@property (nonatomic, readonly, strong) RACSubject *reloadSectionSubject;
/// 评论回调
@property (nonatomic, readonly, strong) RACSubject *commentSubject;

/// 发送评论内容
@property (nonatomic, readonly, strong) RACCommand *commentCommand;
/// 删除当前用户的评论
@property (nonatomic, readonly, strong) RACCommand *delCommentCommand;
/// 删除当前用户的发的说说
@property (nonatomic, readonly, strong) RACCommand *delMomentCommand;
@end
