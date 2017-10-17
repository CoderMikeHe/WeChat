//
//  MHContactsViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHContactsViewModel.h"
#import "MHAddFriendsViewModel.h"
@interface MHContactsViewModel ()
/// addFriendsCommand
@property (nonatomic, readwrite, strong) RACCommand *addFriendsCommand;
@end


@implementation MHContactsViewModel
- (void)initialize
{
    [super initialize];
    
    self.title = @"通讯录";
    
    @weakify(self);
    self.addFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHAddFriendsViewModel *viewModel = [[MHAddFriendsViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
}
@end
