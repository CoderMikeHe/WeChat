//
//  MHCommonSwitchItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonSwitchItemViewModel.h"

@implementation MHCommonSwitchItemViewModel
- (void)setOff:(BOOL)off
{
    _off = off;
    
    [MHPreferenceSettingHelper setBool:off forKey:self.key];
}

- (void)setKey:(NSString *)key
{
    [super setKey:key];
    
    _off = [MHPreferenceSettingHelper boolForKey:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
