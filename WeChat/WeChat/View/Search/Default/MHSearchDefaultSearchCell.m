//
//  MHSearchDefaultSearchCell.m
//  WeChat
//
//  Created by admin on 2020/5/25.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultSearchCell.h"
#import "MHSearchDefaultSearchItemViewModel.h"
@interface MHSearchDefaultSearchCell ()

/// searchImageView
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
/// titleLable
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// subtitleLabel
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
/// searchLabel
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
/// arrowImageView
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchWidthConstraint;


/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultSearchItemViewModel *viewModel;
@end


@implementation MHSearchDefaultSearchCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultSearchCell";
    MHSearchDefaultSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchDefaultSearchItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    if (viewModel.isSearch) {
        self.titleLabel.hidden = self.subtitleLabel.hidden = NO;
        self.searchLabel.hidden = YES;
        
        self.titleLabel.attributedText = viewModel.titleAttr;
        self.subtitleLabel.text = viewModel.subtitle;
        
        UIColor *color = MHColorFromHexString(@"#e75d58");
        self.searchImageView.image = [UIImage mh_svgImageNamed:@"icons_outlined_search-logo.svg" targetSize:CGSizeMake(40.0, 40.0f) tintColor:color];
        self.searchWidthConstraint.constant = 40.0f;
        
    }else {
        self.titleLabel.hidden = self.subtitleLabel.hidden = YES;
        self.searchLabel.hidden = NO;
        self.searchLabel.text = viewModel.searchKeyword;
        
        UIColor *color = MHColorFromHexString(@"#959595");
        self.searchImageView.image = [UIImage mh_svgImageNamed:@"icon_outlined_search_more_magnifier.svg" targetSize:CGSizeMake(24.0, 24.0f) tintColor:color];
        self.searchWidthConstraint.constant = 24.0f;
    }
    
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
