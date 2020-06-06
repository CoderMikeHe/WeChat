//
//  MHDiscoverManagerViewController.m
//  WeChat
//
//  Created by 何千元 on 2020/6/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverManagerViewController.h"

@interface MHDiscoverManagerViewController ()

@end

@implementation MHDiscoverManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubviews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 发一个通知
    [MHNotificationCenter postNotificationName:MHDiscoverDidChangedNotification object:nil];
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT + 9.0, 0, 0, 0);
}

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}





@end
