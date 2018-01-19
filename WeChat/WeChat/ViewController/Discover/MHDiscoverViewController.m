//
//  MHDiscoverViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverViewController.h"
#import "MHMomentCommentCell.h"
@interface MHDiscoverViewController ()

@end

@implementation MHDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MHMomentCommentCell *cell = [[MHMomentCommentCell alloc] init];
    cell.backgroundColor = [UIColor yellowColor];
    cell.mh_width = MH_SCREEN_WIDTH;
    cell.mh_height = 49;
    cell.mh_x = 0;
    cell.mh_y = MH_SCREEN_HEIGHT - 200;
    [self.view addSubview:cell];
    [self.view bringSubviewToFront:cell];
}

@end
