//
//  MHGroupAvatarsItemViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHGroupAvatarsItemViewModel.h"
@interface MHGroupAvatarsItemViewModel ()

/// user
@property (nonatomic, readwrite, strong) MHUser *user;

/// frame
@property (nonatomic, readwrite, assign) CGRect frame;

@end
@implementation MHGroupAvatarsItemViewModel
- (instancetype)initWithUser:(MHUser *)user frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.user = user;
        self.frame = frame;
    }
    return self;
}
@end
