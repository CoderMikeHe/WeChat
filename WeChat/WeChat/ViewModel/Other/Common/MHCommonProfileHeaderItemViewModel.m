//
//  MHCommonProfileHeaderItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonProfileHeaderItemViewModel.h"

@interface MHCommonProfileHeaderItemViewModel ()
/// 用户头像
@property (nonatomic, readwrite, strong) MHUser *user;
@end

@implementation MHCommonProfileHeaderItemViewModel
- (instancetype)initViewModelWithUser:(MHUser *)user{
    if (self = [super init]) {
        self.rowHeight = 76.0f;
        self.user = user;
    }
    return self;
}
@end
