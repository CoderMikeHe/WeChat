//
//  MHGeneralViewController.m
//  WeChat
//
//  Created by senba on 2017/12/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHGeneralViewController.h"
#import "LCActionSheet.h"
@interface MHGeneralViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHGeneralViewModel *viewModel;
@end

@implementation MHGeneralViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.clearChatRecordsSubject subscribeNext:^(id input) {
         @strongify(self);
         @weakify(self);
         LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"将删除所有个人和群的聊天记录" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
             if (buttonIndex == 0) return ;
             /// 退出账号
             @strongify(self);
             [self.viewModel.clearChatRecordsCommand execute:nil];
             
         } otherButtonTitles:@"清空聊天记录", nil];
         NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
         [indexSet addIndex:1];
         sheet.destructiveButtonIndexSet = indexSet;
         [sheet show];
     }];
}

#pragma mark - 初始化
- (void)_setup{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    
}
@end
