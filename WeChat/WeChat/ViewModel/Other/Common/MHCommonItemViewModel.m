//
//  MHCommonItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonItemViewModel.h"

@implementation MHCommonItemViewModel
+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(NSString *)icon{
    MHCommonItemViewModel *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemViewModelWithTitle:(NSString *)title{
    return [self itemViewModelWithTitle:title icon:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectionStyle = UITableViewCellSelectionStyleGray;
        _rowHeight = 44.0f;
    }
    return self;
}
@end
