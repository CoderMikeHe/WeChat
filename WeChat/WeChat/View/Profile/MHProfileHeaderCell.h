//
//  MHProfileHeaderCell.h
//  WeChat
//
//  Created by senba on 2017/9/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"
@interface MHProfileHeaderCell : UITableViewCell<MHReactiveView>
/// 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 空操作
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;
@end
