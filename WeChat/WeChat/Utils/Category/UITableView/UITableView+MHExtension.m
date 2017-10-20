//
//  UITableView+MHExtension.m
//  WeChat
//
//  Created by senba on 2017/5/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UITableView+MHExtension.h"

@implementation UITableView (MHExtension)

- (void)mh_registerCell:(Class)cls {
    
    [self mh_registerCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)mh_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerClass:cls forCellReuseIdentifier:reuseIdentifier];
}



- (void)mh_registerNibCell:(Class)cls {
    [self mh_registerNibCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)mh_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}



@end
