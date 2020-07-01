//
//  MHPulldownAppletViewModel.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletViewModel.h"
#import "MHPulldownAppletItemViewModel.h"

@implementation MHPulldownAppletViewModel


- (void)initialize {
    [super initialize];
    
    /// 配置数据源
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    
    @weakify(self);
    /// 配置测试数据
    MHPulldownAppletItemViewModel *itemViewModel0 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"glory_of_kings" title:@"王者荣耀"];
    MHPulldownAppletItemViewModel *itemViewModel1 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"peace_elite" title:@"和平精英"];
    MHPulldownAppletItemViewModel *itemViewModel2 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"tencent_sports" title:@"腾讯体育+"];
    MHPulldownAppletItemViewModel *itemViewModel3 = [[MHPulldownAppletItemViewModel alloc] initWithAvatar:@"WAMainFrame_More_50x50" title:@""];
    
    /// 配置数据源
    self.dataSource = @[@[itemViewModel0,itemViewModel1,itemViewModel2,itemViewModel3], @[itemViewModel2,itemViewModel1,itemViewModel0]];
}

@end
