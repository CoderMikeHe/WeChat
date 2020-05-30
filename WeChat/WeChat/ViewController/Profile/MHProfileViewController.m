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
/// videoDynamicView
@property (nonatomic, readwrite, weak) UIView *videoDynamicView;

/// viewModel
@property (nonatomic, readonly, strong) MHProfileViewModel *viewModel;
/// cameraBtn
@property (nonatomic, readwrite, weak) UIButton *cameraBtn;
@end

@implementation MHProfileViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子控件
    [self _makeSubViewsConstraints];
}
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
    //
    @weakify(self);
    RAC(self.videoDynamicView, hidden) = [RACObserve(self.viewModel, dataSource) map:^id(NSArray * value) {
        return @(value.count == 0);
    }];
}


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

- (UIEdgeInsets)contentInset{
    // 200 - 76
    return UIEdgeInsetsMake(124.0f, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}


#pragma mark - 初始化
- (void)_setup{
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 添加一个videoDynamicView 视频动态View
    UIView *videoDynamicView = [[UIView alloc] init];
    self.videoDynamicView = videoDynamicView;
    // 默认隐藏
    videoDynamicView.hidden = YES;
    videoDynamicView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:videoDynamicView belowSubview:self.tableView];
    
    /// cameraBtn
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:MHColorFromHexString(@"#1A1A1A")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:[MHColorFromHexString(@"#1A1A1A") colorWithAlphaComponent:0.5]];
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:image forState:UIControlStateNormal];
    [cameraBtn setImage:imageHigh forState:UIControlStateHighlighted];
    [self.view addSubview:cameraBtn];
    self.cameraBtn = cameraBtn;
    cameraBtn.rac_command = self.viewModel.cameraCommand;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.videoDynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT * 0.5);
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-22.0);
        make.top.equalTo(self.view).with.offset(34.0);
        make.size.mas_equalTo(CGSizeMake(24.0f, 24.0f));
    }];
}

@end
