//
//  MHSearchCommonCell.m
//  WeChat
//
//  Created by 何千元 on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonCell.h"
#import "MHSearchCommonItemViewModel.h"
@interface MHSearchCommonCell ()

/// searchImageView
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// relatedContentView
@property (weak, nonatomic) IBOutlet UIView *relatedContentView;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchCommonItemViewModel *viewModel;

@end

@implementation MHSearchCommonCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchCommonCell";
    MHSearchCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchCommonItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *color = MHColorFromHexString(@"#b3b3b3");
    self.searchImageView.image = [UIImage mh_svgImageNamed:@"icons_outlined_search.svg" targetSize:CGSizeMake(18.0, 18.0f) tintColor:color];
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
