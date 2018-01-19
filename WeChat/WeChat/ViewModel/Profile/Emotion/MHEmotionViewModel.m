//
//  MHEmotionViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHEmotionViewModel.h"
#import "MHUsefulEmotionViewModel.h"
#import "MHMoreEmotionViewModel.h"

@implementation MHEmotionViewModel
- (void)initialize {
    [super initialize];
    
    self.title = @"表情";
    
    MHUsefulEmotionViewModel *usefulEmotion = [[MHUsefulEmotionViewModel alloc] initWithServices:self.services params:nil];
    MHMoreEmotionViewModel *moreEmotion = [[MHMoreEmotionViewModel alloc] initWithServices:self.services params:nil];
    
    self.viewModels = @[ usefulEmotion, moreEmotion ];
}
@end
