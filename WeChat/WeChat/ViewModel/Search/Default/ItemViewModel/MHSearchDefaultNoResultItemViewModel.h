//
//  MHSearchDefaultNoResultItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  没有找到"xxx"相关xxx

#import <Foundation/Foundation.h>
#import "MHSearchDefaultItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultNoResultItemViewModel : MHSearchDefaultItemViewModel
/// 显示的富文本
@property (nonatomic, readonly, copy) NSAttributedString *titleAttr;
/// keyword
@property (nonatomic, readonly, copy) NSString *keyword;

// 初始化
- (instancetype)initWithKeyword:(NSString *)keyword searchDefaultType:(MHSearchDefaultType)type;

@end

NS_ASSUME_NONNULL_END
