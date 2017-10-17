//
//  MHCommonFooterView.h
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"
@interface MHCommonFooterView : UITableViewHeaderFooterView<MHReactiveView>
/// init
+ (instancetype)footerViewWithTableView:(UITableView *)tableView;
@end
