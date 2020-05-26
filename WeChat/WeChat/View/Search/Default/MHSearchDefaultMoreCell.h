//
//  MHSearchDefaultMoreCell.h
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  搜索更多的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultMoreCell : UITableViewCell<MHReactiveView>
// generate cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
