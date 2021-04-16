//
//  MHContactInfoContactItemViewModel.h
//  WeChat
//
//  Created by zhangguangqun on 2021/4/16.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHCommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 联系人详情页面最下面的“发消息”、“音视频通话”的cell对应的ViewModel
@interface MHContactInfoContactItemViewModel : MHCommonItemViewModel
/// 图标名称
@property (nonatomic, readonly, copy) NSString *iconName;
/// 文字名称
@property (nonatomic, readonly, copy) NSString *labelString;

- (instancetype)initViewModelWithIconName:(NSString *)iconName andLabelString:(NSString *)labelString;
@end

NS_ASSUME_NONNULL_END
