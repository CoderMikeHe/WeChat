//
//  MHSearchTypeItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"

NS_ASSUME_NONNULL_BEGIN




@interface MHSearchTypeItemViewModel : NSObject

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

@end

NS_ASSUME_NONNULL_END
