//
//  MHSearchCommonSearchCell.m
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonSearchCell.h"

@interface MHSearchCommonSearchCell ()

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// subtitleLabel
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/// descLabel
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/// avatarImageView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end


@implementation MHSearchCommonSearchCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchCommonSearchCell";
    MHSearchCommonSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(id )viewModel {
//    self.viewModel = viewModel;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
