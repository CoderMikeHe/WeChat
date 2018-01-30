//
//  MHProfileInfoViewController.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHProfileInfoViewController.h"
#import "MHProfileInfoFooterView.h"
#import "MHProfileInfoAlbumCell.h"
#import "MHProfileInfoMoreCell.h"
#import "MHProfileInfoZoneCell.h"
#import "MHProfileInfoCell.h"

@interface MHProfileInfoViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHProfileInfoViewModel *viewModel;
@end

@implementation MHProfileInfoViewController

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
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

#pragma mark - 初始化
- (void)_setup{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 创建footerView
    MHProfileInfoFooterView *footerView = [MHProfileInfoFooterView footerView];
    [footerView bindViewModel:self.viewModel];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDelegate * UITableViewDataSource
/// 这里代码比较简单 就直接写死了
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 2) ? 3 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MHProfileInfoCell *cell = [MHProfileInfoCell cellWithTableView:tableView];
        [cell bindViewModel:self.viewModel];
        return cell;
    }else if (indexPath.section == 1 || indexPath.row == 2){
        MHProfileInfoMoreCell *cell = [MHProfileInfoMoreCell cellWithTableView:tableView];
        cell.titleLabel.text = (indexPath.section == 1)?@"设置备注和标签":@"更多";
        [cell setIndexPath:indexPath rowsInSection:(indexPath.section == 1)?1:3];
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        return [MHProfileInfoZoneCell cellWithTableView:tableView];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        MHProfileInfoAlbumCell *cell = [MHProfileInfoAlbumCell cellWithTableView:tableView];
        [cell bindViewModel:self.viewModel];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 87;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        return 88;
    }else{
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == 2)?CGFLOAT_MIN:20;
}


@end
