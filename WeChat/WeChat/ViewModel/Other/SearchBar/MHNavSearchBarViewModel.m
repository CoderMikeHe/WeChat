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


/// 动画cmd
@property (nonatomic, readwrite, strong) RACCommand *animateCommand;

/// 动画ing
@property (nonatomic, readwrite, assign) BOOL animating;

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
    
    @weakify(self);
    self.animateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        // 修改数据
        @strongify(self);
        self.animating = input.boolValue;
        return [RACSignal empty];
    }];
}

@end
