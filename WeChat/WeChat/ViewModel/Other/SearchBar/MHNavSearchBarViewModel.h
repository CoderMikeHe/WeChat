//
//  MHNavSearchBarViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/3.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHSearchTypeItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHNavSearchBarViewModel : NSObject
/// height
@property (nonatomic, readonly, assign) CGFloat height;

/// 编辑  点击 搜索 或者 取消按钮 回调
@property (nonatomic, readwrite, strong) RACSubject *editSubject;

/// searchType
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

/// 文本框输入回调
@property (nonatomic, readwrite, strong) RACSubject *textSubject;
/// 点击键盘搜索
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
/// 点击返回按钮回调
@property (nonatomic, readwrite, strong) RACCommand *backCommand;
/// 点击取消按钮回调
@property (nonatomic, readwrite, strong) RACSubject *cancelSubject;



/// text 文本框显示的东西
@property (nonatomic, readwrite, copy) NSString *text;
/// searchType 搜索类型
@property (nonatomic, readwrite, assign) MHSearchType searchType;
@end

NS_ASSUME_NONNULL_END
