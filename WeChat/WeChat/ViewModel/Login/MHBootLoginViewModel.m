//
//  MHBootLoginViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHBootLoginViewModel.h"
#import "MHLoginViewModel.h"
#import "MHRegisterViewModel.h"
#import "MHLanguageViewModel.h"

@interface MHBootLoginViewModel ()
/// loginCommand
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;
/// registerCommand
@property (nonatomic, readwrite, strong) RACCommand *registerCommand;
/// languageCommand
@property (nonatomic, readwrite, strong) RACCommand *languageCommand;

/// language
@property (nonatomic, readwrite, copy) NSString *language;
/// languageIdstr
@property (nonatomic, readwrite, copy) NSString *languageIdstr;
@end

@implementation MHBootLoginViewModel

- (void)initialize{
    [super initialize];
    /// 隐藏导航条
    self.prefersNavigationBarHidden = YES;
    
    /// 先从偏好设置里面取出languageIdstr
    NSString *language = [MHPreferenceSettingHelper objectForKey:MHPreferenceSettingLanguage];
    if (language) {
        NSArray *array = [language componentsSeparatedByString:@"-"];
        self.language = array.firstObject;
        self.languageIdstr = array.lastObject;
    }else{
        self.language = @"简体中文";
        self.languageIdstr = @"1000";
    }
    
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHLoginViewModel *viewModel = [[MHLoginViewModel alloc] initWithServices:self.services params:nil];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHRegisterViewModel *viewModel = [[MHRegisterViewModel alloc] initWithServices:self.services params:nil];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.languageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHLanguageViewModel *viewModel = [[MHLanguageViewModel alloc] initWithServices:self.services params:@{MHViewModelIDKey:self.languageIdstr}];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        
        /// 回调
        viewModel.callback = ^(MHLanguageItemViewModel * itemViewModel) {
            @strongify(self);
            self.language = itemViewModel.title;
            self.languageIdstr = itemViewModel.idstr;
            /// 存储到偏好设置
            [MHPreferenceSettingHelper setObject:[NSString stringWithFormat:@"%@-%@",self.language , self.languageIdstr] forKey:MHPreferenceSettingLanguage];
        };
        
        return [RACSignal empty];
    }];
}

@end
