//
//  MHEmotionViewController.m
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHEmotionViewController.h"
#import "MHMoreEmotionViewController.h"
#import "MHUsefulEmotionViewController.h"

@interface MHEmotionViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHEmotionViewModel *viewModel;
@end

@implementation MHEmotionViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MHUsefulEmotionViewController *usefulEmotion = [[MHUsefulEmotionViewController alloc] initWithViewModel:self.viewModel.viewModels[0]];
    usefulEmotion.segmentedControlItem = @"精选表情";
    
    MHMoreEmotionViewController *moreEmotion = [[MHMoreEmotionViewController alloc] initWithViewModel:self.viewModel.viewModels[1]];
    moreEmotion.segmentedControlItem = @"更多表情";
    
    self.viewControllers = @[ usefulEmotion, moreEmotion ];
}

@end
