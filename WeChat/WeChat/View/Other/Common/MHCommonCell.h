//
//  MHCommonCell.h
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"

@interface MHCommonCell : UITableViewCell<MHReactiveView>
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;
@end
