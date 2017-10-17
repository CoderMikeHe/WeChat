//
//  MHHomePageViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  主界面的视图的视图模型

#import "MHTabBarViewModel.h"
#import "MHMainFrameViewModel.h"
#import "MHContactsViewModel.h"
#import "MHDiscoverViewModel.h"
#import "MHProfileViewModel.h"
@interface MHHomePageViewModel : MHTabBarViewModel
/// The view model of `MainFrame` interface.
@property (nonatomic, strong, readonly) MHMainFrameViewModel *mainFrameViewModel;

/// The view model of `contacts` interface.
@property (nonatomic, strong, readonly) MHContactsViewModel *contactsViewModel;

/// The view model of `discover` interface.
@property (nonatomic, strong, readonly) MHDiscoverViewModel *discoverViewModel;

/// The view model of `Profile` interface.
@property (nonatomic, strong, readonly) MHProfileViewModel *profileViewModel;
@end
