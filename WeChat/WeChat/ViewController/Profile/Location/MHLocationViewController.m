//
//  MHLocationViewController.m
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLocationViewController.h"

@interface MHLocationViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHLocationViewModel *viewModel;
@end

@implementation MHLocationViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
    
    RAC(self.navigationItem.rightBarButtonItem , enabled) = self.viewModel.validCompleteSignal;
}

#pragma mark - 事件处理
- (void)_complete{
    
    [self.viewModel.completeCommand execute:nil];
}

#pragma mark - 初始化
- (void)_setup{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"取消" titleColor:nil imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.cancelCommand;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"完成" titleColor:MH_MAIN_TINTCOLOR imageName:nil target:self selector:@selector(_complete) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}
@end
