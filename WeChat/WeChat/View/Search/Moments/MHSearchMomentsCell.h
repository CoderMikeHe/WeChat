//
//  MHSearchMomentsCell.h
//  WeChat
//
//  Created by 何千元 on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchMomentsCell : UITableViewCell<MHReactiveView>
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
