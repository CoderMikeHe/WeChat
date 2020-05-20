//
//  MHSearchTypeView.m
//  WeChat
//
//  Created by 何千元 on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchTypeView.h"
#import "MHSearchDefaultSearchTypeItemViewModel.h"
@interface MHSearchTypeView ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultSearchTypeItemViewModel *viewModel;

///
@end

@implementation MHSearchTypeView

#pragma mark - Public Method
/// 构造方法
+ (instancetype)searchTypeView {
    return [self mh_viewFromXib];
}


// 绑定viewModel
- (void)bindViewModel:(MHSearchDefaultSearchTypeItemViewModel *)viewModel {
    self.viewModel = viewModel;
}


#pragma mark - Private Method

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 事件处理

- (IBAction)_btnDidClicked:(UIButton *)sender {
    // 回调
    [self.viewModel.searchTypeSubject sendNext:@(sender.tag)];
}


#pragma mark - 辅助方法
@end
