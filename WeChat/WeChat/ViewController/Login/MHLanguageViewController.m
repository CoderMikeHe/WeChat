//
//  MHLanguageViewController.m
//  WeChat
//
//  Created by senba on 2017/10/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLanguageViewController.h"

@interface MHLanguageViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHLanguageViewModel *viewModel;
@end

@implementation MHLanguageViewController

@dynamic viewModel;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /// 滚动到指定的行
    [self.tableView scrollToRowAtIndexPath:self.viewModel.indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

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
- (void)bindViewModel{
    [super bindViewModel];
    // 完成按钮的有效性
    RAC(self.navigationItem.rightBarButtonItem, enabled) = self.viewModel.validCompleteSignal;
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(MHLanguageItemViewModel *)object{
    cell.accessoryType =(object.selected)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    cell.textLabel.text = object.title;
}

#pragma mark - 事件处理
- (void)_complete{
    [self.viewModel.completeCommand execute:nil];
}

#pragma mark - 初始化
- (void)_setup{
    self.tableView.separatorColor = MHGlobalBottomLineColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"取消" titleColor:nil imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.closeCommand;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"完成" titleColor:MH_MAIN_TINTCOLOR imageName:nil target:self selector:@selector(_complete) textType:YES];
}


#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

@end
