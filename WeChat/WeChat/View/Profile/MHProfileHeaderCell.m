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

/// qrCodeView
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeView;

/// arrowView
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

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
    
    UIImage *image0 = [UIImage mh_svgImageNamed:@"icons_outlined_qr_code.svg" targetSize:CGSizeMake(24, 24) tintColor:MHColorFromHexString(@"#808080")];
    self.qrCodeView.image = image0;
    
    UIImage *image1 = [UIImage mh_svgImageNamed:@"icons_outlined_arrow.svg"];
    self.arrowImageView.image = image1;
    
    @weakify(self);
    /// 绑定数据 因为用户的数据可能随时改变的
    RAC(self.nicknameLabel , text) = RACObserve(self, viewModel.user.screenName);
    RAC(self.wechatNumLabel, text) = [RACObserve(self, viewModel.user.wechatId) map:^id(id value) {
        return [NSString stringWithFormat:@"微信号：%@", value];
    }];
    [[[[RACObserve(self, viewModel.user.profileImageUrl) ignore:nil] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSURL * avatarUrl) {
        @strongify(self);
        [self.avatarView yy_setImageWithURL:avatarUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
