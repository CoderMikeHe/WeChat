//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
@interface MHSearchViewModel ()

/// searchTypeViewModel
@property (nonatomic, readwrite, strong) MHSearchTypeViewModel *searchTypeViewModel;

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

/// searchType
@property (nonatomic, readwrite, assign) MHSearchType searchType;

@end
@implementation MHSearchViewModel


- (void)initialize {
    [super initialize];
    
    self.searchType = -1;
    
    @weakify(self);
    self.searchTypeSubject = [RACSubject subject];
    
    
    // 创建viewModel
    self.searchTypeViewModel = [[MHSearchTypeViewModel alloc] init];
    self.searchTypeViewModel.searchTypeSubject = self.searchTypeSubject;
    
    
}


@end
