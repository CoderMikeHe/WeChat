//
//  MHUserInfoViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

@interface MHUserInfoViewModel : MHCommonViewModel
/// The current `user`.
@property (nonatomic, readonly , strong) MHUser *user;
@end
