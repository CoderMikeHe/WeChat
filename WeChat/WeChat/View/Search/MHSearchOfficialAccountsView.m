//
//  MHSearchOfficialAccountsView.m
//  WeChat
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchOfficialAccountsView.h"

@implementation MHSearchOfficialAccountsView

#pragma mark - Public Method
/// 构造方法
+ (instancetype)officialAccountsView {
    return [self mh_viewFromXib];
}


// 绑定viewModel
- (void)bindViewModel:(id)viewModel {
    
}

#pragma mark - Private Method

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 事件处理

@end
