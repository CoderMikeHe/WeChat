//
//  MHContactInfoViewController.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/14.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoViewController.h"
#import "MhContactInfoViewModel.h"
#import "MHContactInfoHeaderCell.h"
#import "MHContactInfoContactCell.h"

@interface MHContactInfoViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHContactInfoViewModel *viewModel;

@end

@implementation MHContactInfoViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupNavigationItem];
}

/// 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_filled_more.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:nil target:nil selector:nil];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
}


- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 用户信息的cell
    if (indexPath.section == 0 && indexPath.row == 0) return [MHContactInfoHeaderCell cellWithTableView:tableView];
    if (indexPath.section == 2) return [MHContactInfoContactCell cellWithTableView:tableView];
    return [super tableView:tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 用户信息的cell
    if (indexPath.section == 0 && indexPath.row == 0) {
        MHContactInfoHeaderCell *contactInfoHeaderCell = (MHContactInfoHeaderCell *)cell;
        [contactInfoHeaderCell bindViewModel:object];
        return;
    }
    if (indexPath.section == 2) {
        MHContactInfoContactCell *contactInfoContactCell = (MHContactInfoContactCell *)cell;
        [contactInfoContactCell bindViewModel:object];
        return;
    }
    [super configureCell:cell atIndexPath:indexPath withObject:object];
}

@end
