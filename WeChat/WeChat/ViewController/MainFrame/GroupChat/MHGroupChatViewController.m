//
//  MHGroupChatViewController.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHGroupChatViewController.h"

@interface MHGroupChatViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHGroupChatViewModel *viewModel;
@end

@implementation MHGroupChatViewController
@dynamic viewModel;


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

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_filled_more.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:nil target:nil selector:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.moreCommand;
}

/// 初始化子控件
- (void)_setupSubviews{
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}

@end
