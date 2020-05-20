//
//  MHSearchDefaultContactItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  联系人

#import "MHSearchDefaultItemViewModel.h"
#import "WPFPerson.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultContactItemViewModel : MHSearchDefaultItemViewModel
/// avatar 头像 50x50
@property (nonatomic, readonly, strong) NSURL *profileImageUrl;
/// 用户昵称
@property (nonatomic, readonly, copy) NSAttributedString *screenNameAttr;
/// person
@property (nonatomic, readonly, strong) WPFPerson *person;

/// 初始化
- (instancetype)initWithPerson:(WPFPerson *)person;
@end

NS_ASSUME_NONNULL_END
