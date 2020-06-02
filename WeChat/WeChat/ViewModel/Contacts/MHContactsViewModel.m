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

/// 搜索状态
@property (nonatomic, readwrite, assign) MHNavSearchBarState searchState;

/// 弹出/消失 搜索内容页 回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;

@end


@implementation MHContactsViewModel
- (void)initialize
{
    [super initialize];
    
    self.title = @"通讯录";
    
    // iOS 原生汉子转拼音 👍
//    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, CFSTR("芈月"));
//    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
//    NSLog(@"Input PinYin %@", string);
    
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
    
    
    
    // --------------------- 搜索相关 ----------------------
    /// 弹出搜索页或者隐藏搜索页的回调  以及侧滑搜索页回调
    self.popCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([input isKindOfClass:NSNumber.class]) {
            NSNumber *value = (NSNumber *)input;
            self.searchState = value.integerValue;
        } else {
            NSDictionary *dict = (NSDictionary *)input;
            MHSearchPopState state = [dict[@"state"] integerValue];
            if (state == MHSearchPopStateCompleted && self.searchState == MHNavSearchBarStateSearch) {
                self.searchState = MHNavSearchBarStateDefault;
            }
        }
        return [RACSignal return:input];
    }];
 
    // 创建 searchViewModel
    self.searchViewModel = [[MHSearchViewModel alloc] initWithServices:self.services params:@{MHSearchViewPopCommandKey: self.popCommand}];
    

    // 配置 searchBar viewModel
    self.searchBarViewModel = [[MHNavSearchBarViewModel alloc] init];
    // 语音输入回调 + 文本框输入回调
    self.searchBarViewModel.textCommand = self.searchViewModel.textCommand;
    // 返回按钮的命令
    self.searchBarViewModel.backCommand = self.searchViewModel.backCommand;
    // 键盘搜索按钮的命令
    self.searchBarViewModel.searchCommand = self.searchViewModel.searchCommand;
    // 点击 搜索 或者 取消按钮的回调
    self.searchBarViewModel.popCommand = self.popCommand;
    
    /// 赋值操作
    RAC(self.searchBarViewModel, text) = RACObserve(self.searchViewModel, keyword);
    RAC(self.searchBarViewModel, searchType) = RACObserve(self.searchViewModel, searchType);
    RAC(self.searchBarViewModel, searchDefaultType) = RACObserve(self.searchViewModel, searchDefaultType);
    
    RAC(self.searchViewModel, searchState) = RACObserve(self, searchState);
    RAC(self.searchBarViewModel, searchState) = RACObserve(self, searchState);
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
