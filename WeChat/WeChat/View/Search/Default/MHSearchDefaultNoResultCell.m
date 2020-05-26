//
//  MHSearchDefaultNoResultCell.m
//  WeChat
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultNoResultCell.h"
#import "MHSearchDefaultNoResultItemViewModel.h"
@interface MHSearchDefaultNoResultCell ()

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultNoResultItemViewModel *viewModel;

@end
@implementation MHSearchDefaultNoResultCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultNoResultCell";
    MHSearchDefaultNoResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchDefaultNoResultItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleLabel.attributedText = viewModel.titleAttr;
    
}
#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
