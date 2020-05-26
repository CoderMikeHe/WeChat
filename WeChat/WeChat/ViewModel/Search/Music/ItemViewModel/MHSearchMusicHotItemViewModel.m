//
//  MHSearchMusicHotItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicHotItemViewModel.h"
@interface MHSearchMusicHotItemViewModel ()

/// musics
@property (nonatomic, readwrite, copy) NSArray *musics;

/// cellHeight
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

@end
@implementation MHSearchMusicHotItemViewModel

- (instancetype)initWithMusics:(NSArray *)musics {
    if (self = [super init]) {
        self.musics = musics;
        
        // 计算cell高度
        // 计算总页数 int totalPageNum = (totalRecord  +  pageSize  - 1) / pageSize;
        NSInteger totalPageNum = (musics.count + 2 - 1) / 2;
        self.cellHeight = totalPageNum * ([@"隔壁老樊" mh_sizeWithFont:MHRegularFont_14 limitWidth:CGFLOAT_MAX].height + 20) + 20;
    }
    return self;
}

@end
