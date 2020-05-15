//
//  MHSearchMusicHistoryItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicHistoryItemViewModel.h"
@interface MHSearchMusicHistoryItemViewModel ()

/// musics
@property (nonatomic, readwrite, copy) NSString *music;

@end
@implementation MHSearchMusicHistoryItemViewModel
- (instancetype)initWithMusic:(NSString *)music {
    if (self = [super init]) {
        self.music = music;
    }
    return self;
}
@end
