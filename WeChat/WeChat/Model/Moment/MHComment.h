//
//  MHComment.h
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
/// 一条评论

#import "MHObject.h"

@interface MHComment : MHObject
/// 正文
@property (nonatomic, readwrite, copy) NSString *text;
/// idStr(评论的id)
@property (nonatomic, readwrite, copy) NSString *idstr;
/// idStr(评论的说说的id)
@property (nonatomic, readwrite, copy) NSString *momentIdstr;
/// 创建时间
@property (nonatomic, readwrite, strong) NSDate *createdAt;

/// 回复:xxx （目标）
@property (nonatomic, readwrite, strong) MHUser *toUser;
/// xxx: （来源）
@property (nonatomic, readwrite, strong) MHUser *fromUser;
@end
