//
//  UIScrollView+MHRefresh.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  添加上下拉刷新

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@interface UIScrollView (MHRefresh)
/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)mh_addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock;
/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)mh_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock;
@end
