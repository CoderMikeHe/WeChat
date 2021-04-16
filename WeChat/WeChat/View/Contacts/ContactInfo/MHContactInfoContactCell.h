//
//  MHContactInfoContactCell.h
//  WeChat
//
//  Created by zhangguangqun on 2021/4/16.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHContactInfoContactCell : UITableViewCell<MHReactiveView>
/// 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 空操作
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;
@end

NS_ASSUME_NONNULL_END
