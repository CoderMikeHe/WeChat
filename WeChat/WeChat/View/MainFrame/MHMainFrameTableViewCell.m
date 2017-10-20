//
//  MHMainFrameTableViewCell.m
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameTableViewCell.h"
#import "MHMainFrameItemViewModel.h"
@interface MHMainFrameTableViewCell ()
/// viewModel
@property (nonatomic, readwrite, strong) MHMainFrameItemViewModel *viewModel;

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
/// nickenameLabel
@property (weak, nonatomic) IBOutlet UILabel *nickenameLabel;
/// locationBtn
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/// starLevelView
@property (weak, nonatomic) IBOutlet UIImageView *starLevelView;
/// audienceNumsLabel
@property (weak, nonatomic) IBOutlet UILabel *audienceNumsLabel;
/// coverView
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
/// headTipsBtn
@property (weak, nonatomic) IBOutlet UIButton *headTipsBtn;
/// signView
@property (weak, nonatomic) IBOutlet UIImageView *signView;

@end

@implementation MHMainFrameTableViewCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LiveRoomCell";
    MHMainFrameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)bindViewModel:(MHMainFrameItemViewModel *)viewModel{
    self.viewModel = viewModel;
    
    [self.avatarView yy_setImageWithURL:viewModel.liveRoom.smallpic placeholder:MHImageNamed(@"header_default_100x100") options:MHWebImageOptionAutomatic completion:NULL];
    self.signView.hidden = !viewModel.liveRoom.isSign;
    
    self.nickenameLabel.text = viewModel.liveRoom.myname;
    self.starLevelView.image = MHImageNamed(viewModel.girlStar);
    
    [self.locationBtn setTitle:viewModel.liveRoom.gps forState:UIControlStateNormal];
    self.audienceNumsLabel.attributedText = viewModel.allNumAttr;
    
    [self.headTipsBtn setTitle:viewModel.liveRoom.familyName forState:UIControlStateNormal];
    [self.coverView yy_setImageWithURL:viewModel.liveRoom.bigpic placeholder:MHImageNamed(@"placeholder_head_100x100") options:MHWebImageOptionAutomatic completion:NULL];
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
