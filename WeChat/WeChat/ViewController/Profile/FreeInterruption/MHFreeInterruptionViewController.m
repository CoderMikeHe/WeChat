//
//  MHFreeInterruptionViewController.m
//  WeChat
//
//  Created by senba on 2017/12/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHFreeInterruptionViewController.h"

@interface MHFreeInterruptionViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHFreeInterruptionViewModel *viewModel;
@end

@implementation MHFreeInterruptionViewController

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
- (void)bindViewModel{
    [super bindViewModel];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(MHFreeInterruptionItemViewModel *)object{
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
    
    /// 创建footer
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = self.view.backgroundColor;
    
    /// 创建label
    UILabel *textLabel = [UILabel mh_labelWithText:self.viewModel.footer font:MHRegularFont_14 textColor:MHColorFromHexString(@"#888888")];
    [footerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    CGFloat limitWidth = MH_SCREEN_WIDTH - 2 * 20;
    CGFloat height = [self.viewModel.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height;
    self.tableView.tableFooterView = footerView;
    self.tableView.tableFooterView.mh_height = 5*2+height;
    
}


@end
