//
//  MHCommonGroupViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  组视图模型

#import <Foundation/Foundation.h>

@interface MHCommonGroupViewModel : NSObject
/// 组头
@property (nonatomic, copy) NSString *header;
/// headerHeight defalult is .001
@property (nonatomic, readwrite, assign) CGFloat headerHeight;
/// 组尾
@property (nonatomic, copy) NSString *footer;
/// footerHeight defalult is 9
@property (nonatomic, readwrite, assign) CGFloat footerHeight;
/// 里面装着都是 MHCommonItemViewModel 以及其子类
@property (nonatomic, strong) NSArray *itemViewModels;

+ (instancetype)groupViewModel;
@end
