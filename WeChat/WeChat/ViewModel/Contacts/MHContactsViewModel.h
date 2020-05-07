//
//  MHContactsViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHContactsItemViewModel.h"
#import "MHNavSearchBarViewModel.h"

#import "MHSearchViewModel.h"

@interface MHContactsViewModel : MHTableViewModel
/// addFriendsCommand
@property (nonatomic, readonly, strong) RACCommand *addFriendsCommand;

/// searchBarViewModel
@property (nonatomic, readonly, strong) MHNavSearchBarViewModel *searchBarViewModel;
/// searchViewModel
@property (nonatomic, readonly, strong) MHSearchViewModel *searchViewModel;

/// contacts
@property (nonatomic, readonly, strong) NSArray *contacts;

/// 存储联系人 拼音 首字母
@property (nonatomic, readonly, strong) NSArray *letters;

/// 总人数
@property (nonatomic, readonly, copy) NSString *total;


/// 是否点击 🔍 搜索 是编辑状态
/// 编辑回调
@property (nonatomic, readonly, strong) RACSubject *editSubject;

@end
