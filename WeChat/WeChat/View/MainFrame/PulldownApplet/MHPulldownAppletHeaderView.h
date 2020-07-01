//
//  MHPulldownAppletHeaderView.h
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHPulldownAppletHeaderView : UITableViewHeaderFooterView
/// 创建方法
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
