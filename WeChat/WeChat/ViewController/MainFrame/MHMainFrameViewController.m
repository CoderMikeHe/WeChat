//
//  MHMainFrameViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameViewController.h"

@interface MHMainFrameViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHMainFrameViewModel *viewModel;
@end

@implementation MHMainFrameViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
}

#pragma mark - 事件处理
- (void)_addMore{
    MHLogFunc;
}


#pragma mark - 初始化
- (void)_setup{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_add_30x30" target:self selector:@selector(_addMore) textType:NO];
}


@end
