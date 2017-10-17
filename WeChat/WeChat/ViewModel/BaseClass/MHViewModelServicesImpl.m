//
//  MHViewModelServicesImpl.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewModelServicesImpl.h"

@implementation MHViewModelServicesImpl
@synthesize client = _client;
- (instancetype)init
{
    self = [super init];
    if (self) {
         _client = [MHHTTPService sharedInstance];
    }
    return self;
}


#pragma mark - SBNavigationProtocol empty operation
- (void)pushViewModel:(MHViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(MHViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(MHViewModel *)viewModel {}

@end
