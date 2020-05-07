//
//  MHNavSearchBarViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/3.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHNavSearchBarViewModel.h"

@interface MHNavSearchBarViewModel ()

/// height
@property (nonatomic, readwrite, assign) CGFloat height;

@end

@implementation MHNavSearchBarViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    // 默认是 56.0f
    self.height = 56.0f;
}

@end
