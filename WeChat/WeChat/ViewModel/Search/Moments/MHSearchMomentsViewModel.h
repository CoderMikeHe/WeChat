//
//  MHSearchMomentsViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHSearchTypeViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchMomentsViewModel : MHSearchTypeViewModel

/// results
@property (nonatomic, readonly, copy) NSArray *results;

@end

NS_ASSUME_NONNULL_END
