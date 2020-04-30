//
//  MHContactsTableViewCell.m
//  WeChat
//
//  Created by admin on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsTableViewCell.h"
#import "MHContactsItemViewModel.h"
@interface MHContactsTableViewCell ()

/// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

/// 用户昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

/// viewModel
@property (nonatomic, readwrite, strong) MHContactsItemViewModel *viewModel;

@end


@implementation MHContactsTableViewCell

#pragma mark - Public Method
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ContactsCell";
    MHContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHContactsItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    // 数据处理
    if (MHObjectIsNil(viewModel.contact)) {
        self.nicknameLabel.text = viewModel.name;
        self.avatarView.image = MHImageNamed(viewModel.icon);
    }else {
        self.nicknameLabel.text = viewModel.contact.screenName;
        [self.avatarView yy_setImageWithURL:viewModel.contact.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    }
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
