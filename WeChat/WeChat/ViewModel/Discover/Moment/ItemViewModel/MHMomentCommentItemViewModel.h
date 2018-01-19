//
//  MHMomentCommentItemViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentContentViewModel.h"
#import "MHMoments.h"

@interface MHMomentCommentItemViewModel : MHMomentContentViewModel

/// ==== Model Properties ====
/// 评论模型
@property (nonatomic, readonly, strong) MHComment *comment;

/// init
- (instancetype)initWithComment:(MHComment *)comment;
@end
