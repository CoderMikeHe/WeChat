//
//  MHSearchDefaultGroupChatCell.m
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultGroupChatCell.h"
#import "MHSearchDefaultGroupChatItemViewModel.h"
#import "MHGroupAvatarsView.h"
@interface MHSearchDefaultGroupChatCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultGroupChatItemViewModel *viewModel;

/// avatarsView
@property (weak, nonatomic) IBOutlet MHGroupAvatarsView *avatarsView;

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// subtitleLabel
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end


@implementation MHSearchDefaultGroupChatCell
#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchDefaultGroupChatCell";
    MHSearchDefaultGroupChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)bindViewModel:(MHSearchDefaultGroupChatItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.titleLabel.text = viewModel.groupChatName;
    self.subtitleLabel.attributedText = viewModel.subtitleAttr;
    
    [self.avatarsView bindViewModel:viewModel.groupAvatarsViewModel];
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
