//
//  MHSearchMusicHotItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchMusicHotItemViewModel : NSObject

/// musics
@property (nonatomic, readonly, copy) NSArray *musics;

/// cellHeight
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/// 键盘搜索 以及 点击关联结果
@property (nonatomic, readwrite, strong) RACCommand *requestSearchKeywordCommand;

- (instancetype)initWithMusics:(NSArray *)musics;

@end

NS_ASSUME_NONNULL_END
