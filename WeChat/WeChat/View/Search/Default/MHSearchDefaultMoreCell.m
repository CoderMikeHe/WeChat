//
//  MHSearchDefaultMoreCell.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultMoreCell.h"
#import "MHSearchDefaultMoreItemViewModel.h"

@interface MHSearchDefaultMoreCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultMoreItemViewModel *viewModel;
/// searchIconView
@property (weak, nonatomic) IBOutlet UIImageView *searchIconView;
/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MHSearchDefaultMoreCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultMoreCell";
    MHSearchDefaultMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchDefaultMoreItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleLabel.text = viewModel.title;   
    
}
#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = MHColorFromHexString(@"#5b6a91");
    self.searchIconView.image = [UIImage mh_svgImageNamed:@"icon_outlined_search_more_magnifier.svg" targetSize:CGSizeMake(24.0, 24.0f) tintColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
