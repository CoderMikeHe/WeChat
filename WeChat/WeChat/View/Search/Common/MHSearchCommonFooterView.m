//
//  MHSearchCommonFooterView.m
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonFooterView.h"

@implementation MHSearchCommonFooterView

#pragma mark - Public Method

+ (instancetype)footerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchCommonFooterView";
    MHSearchCommonFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [self mh_viewFromXib];
    }
    return header;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

@end
