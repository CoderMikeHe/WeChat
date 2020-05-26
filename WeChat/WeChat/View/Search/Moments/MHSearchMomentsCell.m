//
//  MHSearchMomentsCell.m
//  WeChat
//
//  Created by 何千元 on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMomentsCell.h"
#import "MHSearchMomentsItemViewModel.h"
@interface MHSearchMomentsCell ()

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

/// nicknameLabel
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;


/// viewModel
@property (nonatomic, readwrite, strong) MHSearchMomentsItemViewModel *viewModel;
@end

@implementation MHSearchMomentsCell
#pragma mark - Public Method
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchMomentsCell";
    MHSearchMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchMomentsItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.avatarView yy_setImageWithURL:viewModel.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    
    self.nicknameLabel.attributedText = viewModel.screenNameAttr;
}


- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows {
    
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
