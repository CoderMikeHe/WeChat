//
//  MHSearchCommonHeaderView.h
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchCommonHeaderView : UITableViewHeaderFooterView
/// 创建方法
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
