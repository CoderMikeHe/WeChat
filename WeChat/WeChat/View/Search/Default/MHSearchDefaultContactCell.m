//
//  MHSearchDefaultContactCell.m
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  64

#import "MHSearchDefaultContactCell.h"
#import "MHSearchDefaultContactItemViewModel.h"
@interface MHSearchDefaultContactCell ()

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// nicknameLabel
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

/// viewMOdel
@property (nonatomic, readwrite, strong) MHSearchDefaultContactItemViewModel *viewModel;
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

- (void)bindViewModel:(MHSearchDefaultContactItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.avatarImageView yy_setImageWithURL:viewModel.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    
    self.nicknameLabel.attributedText = viewModel.screenNameAttr;
    
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
