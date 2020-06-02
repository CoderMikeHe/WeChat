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
    return [self itemViewModelWithTitle:title icon:icon svg:NO];
}

+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(NSString *)icon svg:(BOOL)svg {
    MHCommonItemViewModel *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    item.svg = svg;
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
        _svgSize = CGSizeMake(22.0f, 22.0f);
        _rowHeight = 56.0f;
    }
    return self;
}
@end
