//
//  MHVideoTrendsWrapperViewModel.m
//  WeChat
//
//  Created by admin on 2020/8/4.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHVideoTrendsWrapperViewModel.h"


@interface MHVideoTrendsWrapperViewModel ()

/// cameraCommand
@property (nonatomic, readwrite, strong) RACCommand *cameraCommand;

@end


@implementation MHVideoTrendsWrapperViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.cameraCommand = params[MHViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
}
@end
