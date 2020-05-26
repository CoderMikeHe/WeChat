//
//  MHGroupAvatarsViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHGroupAvatarsItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHGroupAvatarsViewModel : NSObject
/// users 群聊用户
@property (nonatomic, readonly, copy) NSArray *users;

/// itemViewModels
@property (nonatomic, readonly, copy) NSArray *itemViewModels;


/// 盒模型尺寸
@property (nonatomic, readonly, assign) CGSize targetSize;
/// 每个用户之间的间距和距离盒模型边缘的距离
@property (nonatomic, readonly, assign) CGFloat innerSpace;
/// 生成一个盒模型 users.count >= 3
- (instancetype)initWithUsers:(NSArray *)users targetSize:(CGSize)targetSize innerSpace:(CGFloat)innerSpace;

@end

NS_ASSUME_NONNULL_END
