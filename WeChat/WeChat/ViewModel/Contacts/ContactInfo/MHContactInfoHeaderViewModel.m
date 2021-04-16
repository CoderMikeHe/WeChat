//
//  MHContactInfoHeaderViewModel.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/15.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoHeaderViewModel.h"

@interface MHContactInfoHeaderViewModel ()
/// 联系人
@property (nonatomic, readwrite, strong) MHUser *user;
@end

@implementation MHContactInfoHeaderViewModel
- (instancetype)initViewModelWithUser:(MHUser *)user{
    if (self = [super init]) {
        self.rowHeight = 106.0f;
        self.user = user;
    }
    return self;
}
@end
