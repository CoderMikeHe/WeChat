//
//  MHSearchMomentsItemViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPFPerson.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchMomentsItemViewModel : NSObject

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
