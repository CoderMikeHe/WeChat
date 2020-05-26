//
//  MHGroupAvatarsItemViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHGroupAvatarsItemViewModel : NSObject


/// user
@property (nonatomic, readonly, strong) MHUser *user;

/// frame
@property (nonatomic, readonly, assign) CGRect frame;


- (instancetype)initWithUser:(MHUser *)user frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
