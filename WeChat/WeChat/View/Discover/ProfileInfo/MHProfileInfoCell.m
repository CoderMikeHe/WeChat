//
//  MHProfileInfoCell.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHProfileInfoCell.h"
#import "MHProfileInfoViewModel.h"
#import "YYPhotoGroupView.h"
@interface MHProfileInfoCell ()
/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
/// screenNameLabel
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
/// wxidLabel
@property (weak, nonatomic) IBOutlet UILabel *wxidLabel;
/// nicknameLabel
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
/// viewModel
@property (nonatomic, readwrite, strong) MHProfileInfoViewModel *viewModel;
@end


@implementation MHProfileInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ProfileInfoCell";
    MHProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    /// 头像添加手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
    [self.avatarView addGestureRecognizer:tapGr];
    /// 事件处理
    [tapGr.rac_gestureSignal subscribeNext:^(id x) {
        ///
        @strongify(self);
        /// 图片浏览
        NSMutableArray *items = [NSMutableArray new];
        CGFloat count = 1;
        for (NSUInteger i = 0; i < count; i++) {
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = self.avatarView;
            item.largeImageURL = self.viewModel.user.profileImageUrl;
            item.largeImageSize = CGSizeMake(180, 180);
            [items addObject:item];
        }
        YYPhotoGroupView *photoBrowser = [[YYPhotoGroupView alloc] initWithGroupItems:items];
        [photoBrowser presentFromImageView:self.avatarView toContainer:self.window animated:YES completion:NULL];
    }];
    
}

- (void)bindViewModel:(MHProfileInfoViewModel *)viewModel{
    self.viewModel = viewModel;
    
    /// 头像
    [self.avatarView yy_setImageWithURL:viewModel.user.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    
    /// 真实名字
    self.screenNameLabel.text = viewModel.user.screenName;
    /// 微信号
    self.wxidLabel.text = [NSString stringWithFormat:@"微信号：%@",viewModel.user.idstr];
    /// 昵称
    self.nicknameLabel.text = [NSString stringWithFormat:@"昵称：%@",viewModel.user.screenName];
}

@end
