//
//  MHContactsItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsItemViewModel.h"

@interface MHContactsItemViewModel ()

/// 联系人
@property (nonatomic, readwrite, strong) MHUser *contact;

/// 头像
@property (nonatomic, readwrite, copy) NSString *icon;

/// 名称
@property (nonatomic, readwrite, copy) NSString *name;
@end


@implementation MHContactsItemViewModel


- (instancetype)initWithContact:(MHUser *)contact {
    if (self = [super init]) {
        self.contact = contact;
    }
    
    return self;
}

- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name {
    if (self = [super init]) {
        self.icon = icon;
        self.name = name;
    }
    
    return self;
}

@end
