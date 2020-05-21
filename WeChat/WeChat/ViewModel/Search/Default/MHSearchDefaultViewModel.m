//
//  MHSearchDefaultViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultViewModel.h"
#import "MHSearchDefaultContactItemViewModel.h"
#import "MHSingleChatViewModel.h"

@interface MHSearchDefaultViewModel ()

/// sectionTitle
@property (nonatomic, readwrite, copy) NSString *sectionTitle;
/// searchDefaultType
@property (nonatomic, readwrite, assign) MHSearchDefaultType searchDefaultType;

@end

@implementation MHSearchDefaultViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        // 传过来的数据源
        NSArray *results = params[MHViewModelUtilKey];
        MHSearchDefaultType searchType = [params[MHViewModelIDKey] integerValue];
        
        NSString *sectionTitle = @"";
        switch (searchType) {
            case MHSearchDefaultTypeContacts:
                sectionTitle = @"联系人";
                break;
                
            default:
                break;
        }
        
        self.sectionTitle = sectionTitle;
        self.dataSource = results.copy;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.style = UITableViewStyleGrouped;
    
    @weakify(self);
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        // 关联模式 点击cell 也是搜索模式
        MHSearchDefaultItemViewModel *itemViewModel = self.dataSource[row];
        
        /// 根据类型判断下钻
        switch (itemViewModel.searchDefaultType) {
            case MHSearchDefaultTypeContacts: /// 下钻联系人聊天
            {
                MHSearchDefaultContactItemViewModel *contactItemViewModel = (MHSearchDefaultContactItemViewModel *)itemViewModel;
                /// 下钻单聊页面
                MHSingleChatViewModel *viewModel = [[MHSingleChatViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey: contactItemViewModel.person.model}];
                [self.services pushViewModel:viewModel animated:YES];
            }
                break;
                
            default:
                break;
        }
        
        return [RACSignal empty];
    }];
}
@end
