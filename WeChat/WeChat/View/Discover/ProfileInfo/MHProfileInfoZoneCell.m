//
//  MHProfileInfoZoneCell.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHProfileInfoZoneCell.h"

@implementation MHProfileInfoZoneCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ProfileInfoZoneCell";
    MHProfileInfoZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
