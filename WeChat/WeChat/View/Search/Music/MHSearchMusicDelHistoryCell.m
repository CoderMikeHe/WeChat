//
//  MHSearchMusicDelHistoryCell.m
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicDelHistoryCell.h"

@interface MHSearchMusicDelHistoryCell ()

/// deleteBtn
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/// deleteBtnLeftConstraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnLeftConstraint;

@end

@implementation MHSearchMusicDelHistoryCell


#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchMusicDelHistoryCell";
    MHSearchMusicDelHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(id)viewModel {
    
}

#pragma mark - Event & Action

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *imageNormal = [UIImage mh_svgImageNamed:@"icons_outlined_delete.svg" targetSize:CGSizeMake(18.0, 18.0f) tintColor:MHColorFromHexString(@"#808080")];
    [self.deleteBtn setBackgroundImage:imageNormal forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = 18.0f + 6.0f + [@"清除历史" mh_sizeWithFont:MHRegularFont_16].width;
    self.deleteBtnLeftConstraint.constant = (self.mh_width - w) * .5f;
}

@end
