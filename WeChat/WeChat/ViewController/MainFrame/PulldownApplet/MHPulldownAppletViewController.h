//
//  MHPulldownAppletViewController.h
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  微信首页 下拉显示小程序 模块

#import "MHTableViewController.h"
#import "MHPulldownAppletViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHPulldownAppletViewController : MHTableViewController
@property (nonatomic,assign) BOOL canScroll;
@end

NS_ASSUME_NONNULL_END
