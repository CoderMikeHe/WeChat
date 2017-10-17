//
//  UIScrollView+MHRefresh.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  添加上下拉刷新

#import "UIScrollView+MHRefresh.h"

@implementation UIScrollView (MHRefresh)
/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)mh_addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock {
    
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshNormalHeader *)strongSelf.mj_header);
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    // Configure normal mj_header
    self.mj_header = mj_header;
    return mj_header;
}

/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)mh_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshAutoNormalFooter *mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshAutoNormalFooter *)strongSelf.mj_footer);
    }];
    // Configure normal mj_footer
    [mj_footer setTitle:@"别拉了，已经到底了..." forState:MJRefreshStateNoMoreData];
    self.mj_footer = mj_footer;
    return mj_footer;
}


@end
