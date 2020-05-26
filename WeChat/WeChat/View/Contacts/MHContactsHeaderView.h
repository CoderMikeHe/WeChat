//
//  MHContactsHeaderView.h
//  WeChat
//
//  Created by 何千元 on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHContactsHeaderView : UITableViewHeaderFooterView<MHReactiveView>
/// generate a header
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

- (void)configColorWithProgress:(double)progress;
@end

NS_ASSUME_NONNULL_END
