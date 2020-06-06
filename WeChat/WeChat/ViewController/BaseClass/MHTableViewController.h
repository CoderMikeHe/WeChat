//
//  MHTableViewController.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有需要显示tableView的自定义的视图控制器的基类

#import "MHViewController.h"
#import "MHTableViewModel.h"
#import "MHTableView.h"
@interface MHTableViewController : MHViewController<UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate>

/// The table view for tableView controller.
/// tableView
@property (nonatomic, readonly, weak) MHTableView *tableView;

/// `tableView` 的内容缩进，default is UIEdgeInsetsMake(64,0,0,0)，you can override it
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// reload tableView data , sub class can override
- (void)reloadData;

/// dequeueReusableCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data 
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
@end
