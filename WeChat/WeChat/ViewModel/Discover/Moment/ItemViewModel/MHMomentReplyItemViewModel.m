//
//  MHMomentReplyItemViewModel.m
//  WeChat
//
//  Created by senba on 2018/1/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHMomentReplyItemViewModel.h"
#import "MHMomentCommentItemViewModel.h"
#import "MHMomentItemViewModel.h"
@interface MHMomentReplyItemViewModel ()
/// 传进来的itemViewModel
@property (nonatomic, readwrite, strong) id itemViewModel;
/// idStr(评论的id)
@property (nonatomic, readwrite, copy) NSString *idstr;
/// momentIdstr(该评论的所处的说说的id)
@property (nonatomic, readwrite, copy) NSString *momentIdstr;
/// 回复:xxx （目标）
@property (nonatomic, readwrite, strong) MHUser *toUser;
/** 是否是 回复:xxx （目标） */
@property (nonatomic, readwrite, assign , getter = isReply) BOOL reply;
@end


@implementation MHMomentReplyItemViewModel
- (instancetype)initWithItemViewModel:(id)itemViewModel{
    self = [super init];
    if (self) {
        
        /// 记录一下
        self.itemViewModel = itemViewModel;
        
        if ([itemViewModel isKindOfClass:MHMomentItemViewModel.class]) { /// 点击 `评论按钮`  评论该说说
            MHMomentItemViewModel *viewModel = (MHMomentItemViewModel *)itemViewModel;
            self.idstr = viewModel.moment.idstr;
            self.momentIdstr = viewModel.moment.idstr;
            self.reply = NO; /// 这里不是回复
            
            
        }else if([itemViewModel isKindOfClass:MHMomentCommentItemViewModel.class]){ /// 点击 `评论Cell` ， 回复某条说说的某条评论
            MHMomentCommentItemViewModel *viewModel = (MHMomentCommentItemViewModel *)itemViewModel;
            self.idstr = viewModel.comment.idstr;
            self.momentIdstr = viewModel.comment.momentIdstr;
            self.reply = YES; /// 回复 fromUser
            self.toUser = viewModel.comment.fromUser;
        }
    }
    
    return self;
}
@end
