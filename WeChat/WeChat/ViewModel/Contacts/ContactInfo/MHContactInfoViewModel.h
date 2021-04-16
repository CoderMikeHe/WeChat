//
//  MHContactInfoViewModel.h
//  WeChat
//
//  Created by zhangguangqun on 2021/4/14.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHContactInfoViewModel : MHCommonViewModel
/// 联系人
@property (nonatomic, readonly, strong) MHUser *contact;

@end

NS_ASSUME_NONNULL_END
