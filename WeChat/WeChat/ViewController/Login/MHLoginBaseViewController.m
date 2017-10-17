//
//  MHLoginBaseViewController.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginBaseViewController.h"

@interface MHLoginBaseViewController ()

@end

@implementation MHLoginBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_3];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MHColorFromHexString(@"#F3F3F3");
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
