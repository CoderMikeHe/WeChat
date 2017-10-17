//
//  MHLanguageViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLanguageViewModel.h"

@interface MHLanguageViewModel ()
/// closeCommand
@property (nonatomic, readwrite, strong) RACCommand *closeCommand;
/// 选中的ViewModel
@property (nonatomic, readwrite, strong) MHLanguageItemViewModel *selectedItemViewModel;
/// 语言ID
@property (nonatomic, readwrite, copy) NSString *languageIdStr;
/// 完成命令
@property (nonatomic, readwrite, strong) RACCommand *completeCommand;
/// 完成按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validCompleteSignal;
/// 选中的indexPath （一进来滚动到指定的界面）
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
@end

@implementation MHLanguageViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.languageIdStr = params[MHViewModelIDKey];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    self.title = @"设置语言";
    
    @weakify(self);
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        /// 三部曲
        self.selectedItemViewModel.selected = NO;
        MHLanguageItemViewModel *itemViewModel = self.dataSource[indexPath.row];
        itemViewModel.selected = YES;
        self.selectedItemViewModel = itemViewModel;

        // “手动触发self.dataSource的KVO”，必写。
        [self willChangeValueForKey:@"dataSource"];
        // “手动触发self.now的KVO”，必写。
        [self didChangeValueForKey:@"dataSource"];
        
        return [RACSignal empty];
    }];
    
    /// 完成cmd
    self.completeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        /// 回调数据
        !self.callback?:self.callback(self.selectedItemViewModel);
        /// 退出界面
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    
    self.validCompleteSignal = [RACObserve(self, selectedItemViewModel) map:^id(MHLanguageItemViewModel * itemViewModel) {
        @strongify(self);
        return @(![itemViewModel.idstr isEqualToString:self.languageIdStr]);
    }];
    
    /// 初始化数据
    [self _configureData];
}


- (void)_configureData{
    
    /// https://www.zybang.com/question/8b478510701184609e88eec8d869f87e.html 国家语言列表 拿走不谢
    NSArray *titles = @[@"简体中文" , @"繁體中文（台灣）" , @"繁體中文（香港）" , @"English" , @"Bahasa Indonesia" , @"Bahasa Melayu" , @"español" , @"한국어" , @"Italiano" , @"日本語" , @"Polski" , @"Português" , @"Русский" ,@"ภาษาไทย", @"Tiếng Việt" ,@"العربية", @"हिन्दी", @"עברית", @"Türkçe", @"Deutsch", @"Français"];
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSInteger i = 1000; i<(titles.count + 1000); i++) {
        MHLanguageItemViewModel *itemViewModel = [MHLanguageItemViewModel itemViewModelWithIdstr:[NSString stringWithFormat:@"%zd",i] title:titles[i-1000]];
        if ([itemViewModel.idstr isEqualToString:self.languageIdStr]) {
            itemViewModel.selected = YES;
            self.selectedItemViewModel = itemViewModel;
            
            self.indexPath = [NSIndexPath indexPathForRow:(i-1000) inSection:0];
        }
        [dataSource addObject:itemViewModel];
    }
    
    self.dataSource = dataSource.copy;

}
@end
