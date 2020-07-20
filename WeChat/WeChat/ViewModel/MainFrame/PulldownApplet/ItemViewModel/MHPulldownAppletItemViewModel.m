//
//  MHPulldownAppletItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/7/1.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletItemViewModel.h"
@interface MHPulldownAppletItemViewModel ()

/// avatar
@property (nonatomic, readwrite, copy) NSString *avatar;
/// title
@property (nonatomic, readwrite, copy) NSString *title;
/// homepage
@property (nonatomic, readwrite, copy) NSString *homepage;

@end
@implementation MHPulldownAppletItemViewModel
- (instancetype)initWithAvatar:(NSString *)avatar title:(NSString *)title{
    return [self initWithAvatar:avatar title:title homepage:nil];
}

- (instancetype)initWithAvatar:(NSString *)avatar title:(NSString *)title homepage:(nullable NSString *)homepage{
    self = [super init];
    if (self) {
        self.avatar = avatar;
        self.title = title;
        self.homepage = homepage;
    }
    return self;
}
@end
