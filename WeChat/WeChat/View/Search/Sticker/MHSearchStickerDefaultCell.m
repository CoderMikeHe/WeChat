//
//  MHSearchStickerDefaultCell.m
//  WeChat
//
//  Created by admin on 2020/5/18.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchStickerDefaultCell.h"
#import "MHSearchStickerDefaultItemViewModel.h"
@interface MHSearchStickerDefaultCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchStickerDefaultItemViewModel *viewModel;

/// stickerLeftView
@property (weak, nonatomic) IBOutlet UIImageView *stickerLeftView;

/// stickerRightView
@property (weak, nonatomic) IBOutlet UIImageView *stickerRightView;

@end
@implementation MHSearchStickerDefaultCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchStickerDefaultCell";
    MHSearchStickerDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchStickerDefaultItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *tintColor = MHColorFromHexString(@"#b3b3b3");
    self.stickerLeftView.image = [UIImage mh_svgImageNamed:@"icons_outlined_sticker.svg" targetSize:CGSizeMake(29, 29) tintColor:tintColor];
    self.stickerRightView.image = [UIImage mh_svgImageNamed:@"icons_add_expression.svg" targetSize:CGSizeMake(30, 30) tintColor:tintColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
