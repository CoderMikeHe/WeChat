//
//  MHPulldownAppletWrapperViewModel.h
//  WeChat
//
//  Created by admin on 2020/7/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MHPulldownAppletViewModel;
@interface MHPulldownAppletWrapperViewModel : MHViewModel
/// appletViewModel
@property (nonatomic, readonly, strong) MHPulldownAppletViewModel *appletViewModel;

/// offsetInfo
@property (nonatomic, readwrite, copy) NSDictionary *offsetInfo;

@end

NS_ASSUME_NONNULL_END
