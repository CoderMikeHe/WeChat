//
//  MHHomePageViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHHomePageViewModel.h"

@interface MHHomePageViewModel ()
/// The view model of `MainFrame` interface.
@property (nonatomic, strong, readwrite) MHMainFrameViewModel *mainFrameViewModel;

/// The view model of `contacts` interface.
@property (nonatomic, strong, readwrite) MHContactsViewModel *contactsViewModel;

/// The view model of `discover` interface.
@property (nonatomic, strong, readwrite) MHDiscoverViewModel *discoverViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readwrite) MHProfileViewModel *profileViewModel;
@end

@implementation MHHomePageViewModel

- (void)initialize {
    [super initialize];
    
    self.mainFrameViewModel  = [[MHMainFrameViewModel alloc] initWithServices:self.services params:nil];
    self.contactsViewModel   = [[MHContactsViewModel alloc] initWithServices:self.services params:nil];
    self.discoverViewModel   = [[MHDiscoverViewModel alloc] initWithServices:self.services params:nil];
    self.profileViewModel    = [[MHProfileViewModel alloc] initWithServices:self.services params:nil];
}

@end
