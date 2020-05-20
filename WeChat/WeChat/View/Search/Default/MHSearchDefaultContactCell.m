//
//  MHSearchDefaultContactCell.m
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  64

#import "MHSearchDefaultContactCell.h"
@interface MHSearchDefaultContactCell ()

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// nicknameLabel
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;


@end
@implementation MHSearchDefaultContactCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultContactCell";
    MHSearchDefaultContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
