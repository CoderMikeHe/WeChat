//
//  MHSearchCommonHeaderView.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonHeaderView.h"

@implementation MHSearchCommonHeaderView

#pragma mark - Public Method

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchCommonHeaderView";
    MHSearchCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [self mh_viewFromXib];
    }
    return header;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = MHColorFromHexString(@"#ffffff");
}

@end
