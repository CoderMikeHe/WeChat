//
//  MHPulldownAppletWrapperViewModel.m
//  WeChat
//
//  Created by admin on 2020/7/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletWrapperViewModel.h"
#import "MHPulldownAppletViewModel.h"

@interface MHPulldownAppletWrapperViewModel ()

/// appletViewModel
@property (nonatomic, readwrite, strong) MHPulldownAppletViewModel *appletViewModel;

@end

@implementation MHPulldownAppletWrapperViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    self.appletViewModel = [[MHPulldownAppletViewModel alloc] initWithServices:self.services params:nil];
    
    
    
}

@end
