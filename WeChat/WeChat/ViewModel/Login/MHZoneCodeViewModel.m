//
//  MHZoneCodeViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/28.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHZoneCodeViewModel.h"
@interface MHZoneCodeViewModel ()
/// closeCommand
@property (nonatomic, readwrite, strong) RACCommand *closeCommand;
@end
@implementation MHZoneCodeViewModel
- (void)initialize{
    [super initialize];
    self.title = @"选择国家和地区";
    
    @weakify(self);
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
}
@end
