//
//  MHContactsViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHContactsViewModel.h"
#import "MHAddFriendsViewModel.h"
#import "MHContactsService.h"
#import "WPFPinYinTools.h"
#import "WPFPinYinDataManager.h"

@interface MHContactsViewModel ()
/// addFriendsCommand
@property (nonatomic, readwrite, strong) RACCommand *addFriendsCommand;

/// contacts
@property (nonatomic, readwrite, strong) NSArray *contacts;

/// 存储联系人 拼音 首字母
@property (nonatomic, readwrite, strong) NSArray *letters;

/// 总人数
@property (nonatomic, readwrite, copy) NSString *total;

/// searchBarViewModel
@property (nonatomic, readwrite, strong) MHNavSearchBarViewModel *searchBarViewModel;
/// searchViewModel
@property (nonatomic, readwrite, strong) MHSearchViewModel *searchViewModel;

/// 编辑回调
@property (nonatomic, readwrite, strong) RACSubject *editSubject;
/// searchType
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

@end


@implementation MHContactsViewModel
- (void)initialize
{
    [super initialize];
    
    self.title = @"通讯录";
    
    /// 隐藏导航栏
    self.prefersNavigationBarHidden = YES;
    self.prefersNavigationBarBottomLineHidden = YES;
    
    self.shouldMultiSections = YES;
    
    
    
    @weakify(self);
    self.addFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHAddFriendsViewModel *viewModel = [[MHAddFriendsViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    // 赋值数据
    RAC(self, contacts) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    // 监听数据改变
    [[RACObserve(self, contacts) distinctUntilChanged] subscribeNext:^(NSArray * contacts) {
        @strongify(self);
        [self _handleContacts:contacts];
    }];
    
    
    /// 点击 🔍 搜索
    self.editSubject = [RACSubject subject];
    
    
    // 创建 searchViewModel
    self.searchViewModel = [[MHSearchViewModel alloc] initWithServices:self.services params:nil];
    
    
    // 配置 searchBar viewModel
    self.searchBarViewModel = [[MHNavSearchBarViewModel alloc] init];
    self.searchBarViewModel.editSubject = self.editSubject;
    self.searchBarViewModel.searchTypeSubject = self.searchViewModel.searchTypeSubject;
    
    /// 监听searchViewModel 的 searchType 改变
//    RAC(self.searchBarViewModel, searchType) = [RACObserve(self.searchViewModel, searchType) distinctUntilChanged] ;
}


/// 获取联系人列表
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    // 获取联系人信息
    return [[MHContactsService sharedInstance] fetchContacts];
}


#pragma mark - 辅助方法
- (void)_handleContacts:(NSArray *)contacts {
    if (MHObjectIsNil(contacts) || contacts.count == 0) return;
    
    // 计算总人数
    self.total = [NSString stringWithFormat:@"%ld位联系人",contacts.count];
    
    
    // 这里需要处理数据
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    // 获取首字母
    for(MHUser *contact in contacts){
        // 存到字典中去 <ps: 由于 contacts.json 的wechatId 都是拼音 so...>
        [tempDict setObject:contact forKey:[[contact.wechatId substringToIndex:1] uppercaseString]];
    }
    
    
    //排序，排序的根据是字母
    NSComparator comparator = ^(id obj1, id obj2) {
        if ([obj1 characterAtIndex:0] > [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 characterAtIndex:0] < [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    // 已经排好序的数据
    NSMutableArray *letters = [tempDict.allKeys sortedArrayUsingComparator: comparator].mutableCopy;
    
    
    NSMutableArray *viewModels = [NSMutableArray array];
    
    /// 遍历数据
    for (NSString *letter in letters) {
        // 存储相同首字母 对象
        NSMutableArray *temps = [[NSMutableArray alloc] init];
        // 存到数组中去
        for (NSInteger i = 0; i<contacts.count; i++) {
            MHUser *contact = contacts[i];
            if ([letter isEqualToString:[[contact.wechatId substringToIndex:1] uppercaseString]]) {
                MHContactsItemViewModel *viewModel = [[MHContactsItemViewModel alloc] initWithContact:contact];
                [temps addObject:viewModel];
            }
        }
        [viewModels addObject:temps];
    }
    
    /// 需要配置 新的朋友、群聊、标签、公众号、
    MHContactsItemViewModel *friends = [[MHContactsItemViewModel alloc] initWithIcon:@"plugins_FriendNotify_36x36" name:@"新的朋友"];
    MHContactsItemViewModel *groups = [[MHContactsItemViewModel alloc] initWithIcon:@"add_friend_icon_addgroup_36x36" name:@"群聊"];
    MHContactsItemViewModel *tags = [[MHContactsItemViewModel alloc] initWithIcon:@"Contact_icon_ContactTag_36x36" name:@"标签"];
    MHContactsItemViewModel *officals = [[MHContactsItemViewModel alloc] initWithIcon:@"add_friend_icon_offical_36x36" name:@"公众号"];

    
    
    // 插入到第一个位置
    [viewModels insertObject:@[friends,groups,tags,officals] atIndex:0];
    
    // 插入一个
    [letters insertObject:UITableViewIndexSearch atIndex:0];
    
    self.dataSource = viewModels.copy;
    self.letters = letters.copy;
}






@end
