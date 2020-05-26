//
//  MHSearchDefaultMoreItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultMoreItemViewModel.h"
@interface MHSearchDefaultMoreItemViewModel ()

/// results
@property (nonatomic, readwrite, copy) NSArray *results;

@end
@implementation MHSearchDefaultMoreItemViewModel

- (instancetype)initWithResults:(NSArray *)results;
{
    self = [super init];
    if (self) {
        self.results = results.copy;
    }
    return self;
}


- (CGFloat)cellHeight {
    return 45.0f;
}

@end
