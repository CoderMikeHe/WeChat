//
//  MHSearchCommonSearchCell.h
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchCommonSearchCell : UITableViewCell<MHReactiveView>
// generate cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
