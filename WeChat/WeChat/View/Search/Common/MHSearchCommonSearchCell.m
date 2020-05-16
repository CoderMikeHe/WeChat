//
//  MHSearchCommonSearchCell.m
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonSearchCell.h"
#import "MHSearchCommonSearchItemViewModel.h"
@interface MHSearchCommonSearchCell ()

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// subtitleLabel
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/// descLabel
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/// avatarImageView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


/// viewModel
@property (nonatomic, readwrite, strong) MHSearchCommonSearchItemViewModel *viewModel;
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

- (void)bindViewModel:(MHSearchCommonSearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleLabel.attributedText = viewModel.titleAttr;
    self.subtitleLabel.text = viewModel.subtitle;
    self.descLabel.text = viewModel.desc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置圆角
    [self.avatarImageView zy_cornerRadiusRoundingRect];
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:@"http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg"] placeholder:MHWebImagePlaceholder() options:MHWebImageOptionAutomatic completion:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
