//
//  MHMomentHeaderView.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信朋友圈正文 view

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"

@interface MHMomentHeaderView : UITableViewHeaderFooterView<MHReactiveView>
/// 段
@property (nonatomic, readwrite, assign) NSInteger section;

/// generate a header
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;


@end
