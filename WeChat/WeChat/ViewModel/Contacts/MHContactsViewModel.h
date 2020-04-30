//
//  MHContactsViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHContactsItemViewModel.h"

@interface MHContactsViewModel : MHTableViewModel
/// addFriendsCommand
@property (nonatomic, readonly, strong) RACCommand *addFriendsCommand;

/// contacts
@property (nonatomic, readonly, strong) NSArray *contacts;

/// 存储联系人 拼音 首字母
@property (nonatomic, readonly, strong) NSArray *letters;
@end
