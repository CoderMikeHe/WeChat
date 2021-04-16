//
//  MHContactInfoContactCell.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/16.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoContactCell.h"
#import "MHContactInfoContactItemViewModel.h"

@interface MHContactInfoContactCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// viewModel
@property (nonatomic, readwrite, strong) MHContactInfoContactItemViewModel *viewModel;
@end


@implementation MHContactInfoContactCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ContactInfoContactCell";
    MHContactInfoContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)bindViewModel:(MHContactInfoContactItemViewModel *)viewModel{
    self.viewModel = viewModel;
    self.iconImage.image = [UIImage mh_svgImageNamed:self.viewModel.iconName targetSize:CGSizeMake(25.0, 25.0) tintColor:MHColorFromHexString(@"#586C95")];
    self.titleLabel.text = self.viewModel.labelString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/// 防止Crash
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows{}
@end
