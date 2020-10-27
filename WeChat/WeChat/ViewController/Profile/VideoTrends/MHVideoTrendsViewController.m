//
//  MHVideoTrendsViewController.m
//  WeChat
//
//  Created by admin on 2020/8/4.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHVideoTrendsViewController.h"

@interface MHVideoTrendsViewController ()

@end

@implementation MHVideoTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
}

@end
