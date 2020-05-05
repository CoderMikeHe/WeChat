//
//  MHNavSearchBarViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/3.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHNavSearchBarViewModel : NSObject
/// height
@property (nonatomic, readonly, assign) CGFloat height;

/// 动画cmd
@property (nonatomic, readonly, strong) RACCommand *animateCommand;

/// 动画ing
@property (nonatomic, readonly, assign) BOOL animating;
@end

NS_ASSUME_NONNULL_END
