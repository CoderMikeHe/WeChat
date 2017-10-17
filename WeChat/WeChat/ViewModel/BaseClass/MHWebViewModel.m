//
//  MHWebViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHWebViewModel.h"

@implementation MHWebViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.request = params[MHViewModelRequestKey];
    }
    return self;
}
@end

