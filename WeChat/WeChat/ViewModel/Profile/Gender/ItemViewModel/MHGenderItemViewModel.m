//
//  MHGenderItemViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHGenderItemViewModel.h"
@interface MHGenderItemViewModel ()
/// title
@property (nonatomic, readwrite, copy) NSString *title;
/// idstr
@property (nonatomic, readwrite, copy) NSString *idstr;
@end

@implementation MHGenderItemViewModel

+ (instancetype)itemViewModelWithIdstr:(NSString *)idstr title:(NSString *)title{
    return [[self alloc] initItemViewModelWithIdstr:idstr title:title];
}
- (instancetype)initItemViewModelWithIdstr:(NSString *)idstr title:(NSString *)title
{
    if (self = [super init]) {
        self.idstr = idstr;
        self.title = title;
    }
    return self;
}
@end
