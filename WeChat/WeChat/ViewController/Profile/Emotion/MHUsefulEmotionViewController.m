//
//  MHUsefulEmotionViewController.m
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHUsefulEmotionViewController.h"

@interface MHUsefulEmotionViewController ()

@end

@implementation MHUsefulEmotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    NSLog(@" viewDidLoad 精选表情 .... ");
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@" vwil 精选表情 .... ");
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@" viewWillDisappear 精选表情 .... ");
}


#pragma mark - 初始化
- (void)_setup{
    self.tableView.backgroundColor = [UIColor redColor];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

@end
