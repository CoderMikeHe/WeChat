//
//  MHSearchMusicViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicViewModel.h"

@interface MHSearchMusicViewModel ()

/// tapItemCommand
@property (nonatomic, readwrite, strong) RACCommand *tapItemCommand;

@end


@implementation MHSearchMusicViewModel
- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    
    /// 配置热门音乐
    NSArray *musics = @[@"你我不一", @"隔壁老樊", @"晴天", @"周杰伦", @"中毒", @"野区歌神", @"喉咙唱的沙哑", @"枯木逢春"];
    /// 转换成 itemViewModel
    MHSearchMusicHotItemViewModel *hotItemViewModel = [[MHSearchMusicHotItemViewModel alloc] initWithMusics:musics];
    self.dataSource = @[@[hotItemViewModel],@[@0, @1, @2], @[@2]];
}
@end
