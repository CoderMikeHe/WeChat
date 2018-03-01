//
//  MHSearchFriendsViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

@interface MHSearchFriendsViewModel : MHTableViewModel
/// searchText
@property (nonatomic, readwrite, copy) NSString *searchText;

/// searchCommand
@property (nonatomic, readonly, strong) RACCommand *searchCommand;
@end
