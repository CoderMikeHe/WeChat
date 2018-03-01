//
//  MHSearchFriendsHeaderViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHUser.h"
@interface MHSearchFriendsHeaderViewModel : NSObject

/// Current login User
@property (nonatomic, readonly, strong) MHUser * user;

/// searchCmd
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

/// init
- (instancetype)initWithUser:(MHUser *)user;


@end
