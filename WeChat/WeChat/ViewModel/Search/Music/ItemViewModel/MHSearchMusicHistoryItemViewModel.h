//
//  MHSearchMusicHistoryItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchMusicHistoryItemViewModel : NSObject

/// musics
@property (nonatomic, readonly, copy) NSString *music;
/// clearMusicCommand
@property (nonatomic, readwrite, strong) RACCommand *clearMusicCommand;

- (instancetype)initWithMusic:(NSString *)music;
@end

NS_ASSUME_NONNULL_END
