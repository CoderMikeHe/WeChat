//
//  MHContactInfoHeaderViewModel.h
//  WeChat
//
//  Created by zhangguangqun on 2021/4/15.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHCommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

// 联系人详情页面最上面有头像的cell对应的ViewModel
@interface MHContactInfoHeaderViewModel : MHCommonItemViewModel
/// 联系人
@property (nonatomic, readonly, strong) MHUser *user;


- (instancetype)initViewModelWithUser:(MHUser *)user;
@end

NS_ASSUME_NONNULL_END
