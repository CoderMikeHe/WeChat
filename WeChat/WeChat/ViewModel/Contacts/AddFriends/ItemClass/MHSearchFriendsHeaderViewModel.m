//
//  MHSearchFriendsHeaderViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSearchFriendsHeaderViewModel.h"

@interface MHSearchFriendsHeaderViewModel ()
/// Current login User
@property (nonatomic, readwrite, strong) MHUser * user;
@end

@implementation MHSearchFriendsHeaderViewModel
- (instancetype)initWithUser:(MHUser *)user{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}
@end
