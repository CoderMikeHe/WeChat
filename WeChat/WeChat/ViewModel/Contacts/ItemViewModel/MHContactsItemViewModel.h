//
//  MHContactsItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHContactsItemViewModel : NSObject

/// 联系人
@property (nonatomic, readonly, strong) MHUser *contact;

/// 头像
@property (nonatomic, readonly, copy) NSString *icon;

/// 名称
@property (nonatomic, readonly, copy) NSString *name;

// 初始化
- (instancetype)initWithContact:(MHUser *)contact;

/// 初始化一些本地文件
- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
