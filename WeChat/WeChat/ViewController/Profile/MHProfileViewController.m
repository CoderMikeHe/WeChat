//
//  MHProfileViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHProfileViewController.h"
#import "MHProfileHeaderCell.h"
@interface MHProfileViewController ()

@end

@implementation MHProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@" , self.title);
    
}
#pragma mark - Override
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 用户信息的cell
    if (indexPath.section == 0) return [MHProfileHeaderCell cellWithTableView:tableView];
    return [super tableView:tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 用户信息的cell
    if (indexPath.section == 0) {
        MHProfileHeaderCell *profileHeaderCell = (MHProfileHeaderCell *)cell;
        [profileHeaderCell bindViewModel:object];
        return;
    }
    
    [super configureCell:cell atIndexPath:indexPath withObject:object];
}

@end
