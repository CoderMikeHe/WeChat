//
//  MHProfileHeaderCell.m
//  WeChat
//
//  Created by senba on 2017/9/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHProfileHeaderCell.h"
#import "MHCommonProfileHeaderItemViewModel.h"
@interface MHProfileHeaderCell ()

/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
/// 微信号
@property (weak, nonatomic) IBOutlet UILabel *wechatNumLabel;

/// viewModel
@property (nonatomic, readwrite, strong) MHCommonProfileHeaderItemViewModel *viewModel;
@end

@implementation MHProfileHeaderCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ProfileHeaderCell";
    MHProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)bindViewModel:(MHCommonProfileHeaderItemViewModel *)viewModel{
    self.viewModel = viewModel;
}
/// 防止Crash
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows{}

#pragma mark - Privite Method
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /// 绑定数据 因为用户的数据可能随时改变的
    RAC(self.nicknameLabel , text) = RACObserve(self, viewModel.user.screenName);
    RAC(self.wechatNumLabel, text) = RACObserve(self, viewModel.user.wechatId);
    [[[[RACObserve(self, viewModel.user.profileImageUrl) ignore:nil] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSURL * avatarUrl) {
        [self.avatarView yy_setImageWithURL:avatarUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
