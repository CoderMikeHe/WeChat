//
//  MHMainFrameTableViewCell.h
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"
@interface MHMainFrameTableViewCell : UITableViewCell<MHReactiveView>
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
