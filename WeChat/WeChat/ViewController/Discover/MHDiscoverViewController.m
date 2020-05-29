//
//  MHDiscoverViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverViewController.h"

@interface MHDiscoverViewController ()

@end

@implementation MHDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}
@end
