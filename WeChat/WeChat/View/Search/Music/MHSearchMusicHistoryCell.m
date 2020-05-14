//
//  MHSearchMusicHistoryCell.m
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicHistoryCell.h"

@interface MHSearchMusicHistoryCell ()

/// timeImageView
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;


/// musicNameLabel
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;

/// deleteBtn
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation MHSearchMusicHistoryCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchMusicHistoryCell";
    MHSearchMusicHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(id)viewModel {

}

#pragma mark - Event & Action

- (IBAction)_deleteBtnDidClick:(UIButton *)sender {
    
    
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];

    self.timeImageView.image = [UIImage mh_svgImageNamed:@"icons_outlined_time.svg" targetSize:CGSizeMake(24.0, 24.0f) tintColor:MHColorFromHexString(@"#808080")];

    
    [self.deleteBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(56.0f, 56.0f)] forState:UIControlStateHighlighted];
    
    UIImage *imageNormal = [UIImage mh_svgImageNamed:@"icons_outlined_close.svg" targetSize:CGSizeMake(24.0, 24.0f) tintColor:MHColorFromHexString(@"#808080")];
    [self.deleteBtn setImage:imageNormal forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
