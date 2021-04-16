//
//  MHContactInfoContactItemViewModel.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/16.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoContactItemViewModel.h"

@interface MHContactInfoContactItemViewModel ()
/// 图标名称
@property (nonatomic, readwrite, copy) NSString *iconName;
/// 文字名称
@property (nonatomic, readwrite, copy) NSString *labelString;
@end

@implementation MHContactInfoContactItemViewModel
- (instancetype)initViewModelWithIconName:(NSString *)iconName andLabelString:(NSString *)labelString {
    if (self = [super init]) {
        _iconName = iconName;
        _labelString = labelString;
    }
    return self;
}
@end
