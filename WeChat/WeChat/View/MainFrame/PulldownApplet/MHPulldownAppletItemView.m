//
//  MHPulldownAppletItemView.m
//  WeChat
//
//  Created by admin on 2020/7/1.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletItemView.h"
#import "MHPulldownAppletItemViewModel.h"


@interface MHPulldownAppletItemView ()

/// avatarImageView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// viewMdoel
@property (nonatomic, readwrite, strong) MHPulldownAppletItemViewModel *viewModel;

@end
@implementation MHPulldownAppletItemView

#pragma mark - Public Method
// 初始化
+(instancetype)appletItemView {
    return [self mh_viewFromXib];
}

- (void)bindViewModel:(MHPulldownAppletItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.avatarImageView.image = [UIImage imageNamed:viewModel.avatar];
    self.titleLabel.text = viewModel.title;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}
@end
