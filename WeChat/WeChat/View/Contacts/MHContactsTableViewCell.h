//
//  MHContactsTableViewCell.h
//  WeChat
//
//  Created by admin on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHContactsTableViewCell : UITableViewCell<MHReactiveView>
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
