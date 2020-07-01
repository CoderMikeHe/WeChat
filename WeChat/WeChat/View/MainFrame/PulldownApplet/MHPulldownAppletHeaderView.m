//
//  MHPulldownAppletHeaderView.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletHeaderView.h"

@implementation MHPulldownAppletHeaderView


#pragma mark - Public Method

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"PulldownAppletHeaderView";
    MHPulldownAppletHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [self mh_viewFromXib];
    }
    return header;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

@end
