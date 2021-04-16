//
//  MHContactInfoCell.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/15.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoHeaderCell.h"
#import "MHContactInfoHeaderViewModel.h"

@interface MHContactInfoHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameCommentLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *wechatIdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImage;

/// viewModel
@property (nonatomic, readwrite, strong) MHContactInfoHeaderViewModel *viewModel;
@end

@implementation MHContactInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ContactInfoHeaderCell";
    MHContactInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)bindViewModel:(MHContactInfoHeaderViewModel *)viewModel{
    self.viewModel = viewModel;
    self.nickNameLabel.text = self.viewModel.user.screenName;
    self.wechatIdLabel.text = self.viewModel.user.wechatId;
    self.nameCommentLabel.text = self.viewModel.user.screenName;
    [self.avatarImageView yy_setImageWithURL:self.viewModel.user.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    self.genderImage.image = self.viewModel.user.gender == 0?MHImageNamed(@"Contact_Male_18x18.png"):MHImageNamed(@"Contact_Female_18x18.png");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/// 防止Crash
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows{}

@end
