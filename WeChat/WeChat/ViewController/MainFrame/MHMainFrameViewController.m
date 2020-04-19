//
//  MHMainFrameViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameViewController.h"
#import "MHMainFrameTableViewCell.h"
#import "MHTestViewController.h"
#import "MHCameraViewController.h"
@interface MHMainFrameViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHMainFrameViewModel *viewModel;
@end

@implementation MHMainFrameViewController

@dynamic viewModel;

/// 子类代码逻辑
- (void)viewDidLoad {
    /// ①：子类调用父类的viewDidLoad方法，而父类主要是创建tableView以及强行布局子控件，从而导致tableView刷新，这样就会去走tableView的数据源方法
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// ③：注册cell
    [self.tableView mh_registerNibCell:MHMainFrameTableViewCell.class];
}




#pragma mark - Override
/// 配置tableView的区域
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    // ②：父类的tableView的数据源方法的获取cell是通过注册cell的identifier来获取cell，然而此时子类并未注册cell，所以取出来的cell = nil而引发Crash
    return [tableView dequeueReusableCellWithIdentifier:@"MHMainFrameTableViewCell"];
    // 非注册cell 使用时：去掉ViewDidLoad里面注册Cell的代码
    //    return [MHMainFrameTableViewCell cellWithTableView:tableView];
}


/// 绑定数据
- (void)configureCell:(MHMainFrameTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - 事件处理
- (void)_addMore{
}

#pragma mark - 初始化
- (void)_setup{
    /// set up ...
}
#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_outlined_add2.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:nil target:self selector:@selector(_addMore)];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel.dataSource[indexPath.row] cellHeight];
}
@end
