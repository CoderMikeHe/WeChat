//
//  MHSearchDefaultViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHSearchDefaultItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultViewModel : MHTableViewModel
/// sectionTitle
@property (nonatomic, readonly, copy) NSString *sectionTitle;
/// searchDefaultType
@property (nonatomic, readonly, assign) MHSearchDefaultType searchDefaultType;
@end

NS_ASSUME_NONNULL_END
