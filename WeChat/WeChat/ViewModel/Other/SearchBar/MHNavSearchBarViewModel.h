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

/// 文本框输入回调
@property (nonatomic, readwrite, strong) RACCommand *textCommand;
/// 点击键盘搜索按钮
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
/// 点击返回按钮回调
@property (nonatomic, readwrite, strong) RACCommand *backCommand;
/// 弹出/消失 搜索内容页 回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;


/// text 文本框显示的东西
@property (nonatomic, readwrite, copy) NSString *text;
/// searchType 搜索类型
@property (nonatomic, readwrite, assign) MHSearchType searchType;
/// 搜索状态
@property (nonatomic, readwrite, assign) MHNavSearchBarState searchState;
@end

NS_ASSUME_NONNULL_END
