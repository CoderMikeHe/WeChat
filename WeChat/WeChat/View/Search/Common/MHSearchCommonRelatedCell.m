//
//  MHSearchCommonRelatedCell.m
//  WeChat
//
//  Created by 何千元 on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonRelatedCell.h"
#import "MHSearchCommonRelatedItemViewModel.h"
@interface MHSearchCommonRelatedCell ()

/// searchImageView
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// relatedContentView
@property (weak, nonatomic) IBOutlet UIView *relatedContentView;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchCommonRelatedItemViewModel *viewModel;

@end

@implementation MHSearchCommonRelatedCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchCommonCell";
    MHSearchCommonRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchCommonRelatedItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleLabel.attributedText = viewModel.titleAttr;
    
}

#pragma mark - 事件处理


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    UIColor *color = MHColorFromHexString(@"#b3b3b3");
    self.searchImageView.image = [UIImage mh_svgImageNamed:@"icons_outlined_search.svg" targetSize:CGSizeMake(18.0, 18.0f) tintColor:color];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
    [self.relatedContentView addGestureRecognizer:tapGr];
    [tapGr.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.relatedKeywordCommand execute: self.viewModel.title];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
