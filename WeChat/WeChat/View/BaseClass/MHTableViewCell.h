//
//  MHTableViewCell.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTableViewCell : UITableViewCell

/// init 子类可以重写，无需调用 super xxx
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
