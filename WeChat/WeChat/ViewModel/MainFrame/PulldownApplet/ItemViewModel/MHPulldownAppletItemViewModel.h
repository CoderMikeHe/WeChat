//
//  MHPulldownAppletItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/7/1.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHPulldownAppletItemViewModel : NSObject

/// avatar
@property (nonatomic, readonly, copy) NSString *avatar;
/// title
@property (nonatomic, readonly, copy) NSString *title;
/// homepage
@property (nonatomic, readonly, copy) NSString *homepage;

/// 点击事件
@property (nonatomic, readwrite, strong) RACCommand *didTapItemCommand;


- (instancetype)initWithAvatar:(NSString *)avatar title:(NSString *)title;
- (instancetype)initWithAvatar:(NSString *)avatar title:(NSString *)title homepage:(nullable NSString *)homepage;
@end

NS_ASSUME_NONNULL_END
