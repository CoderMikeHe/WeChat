//
//  MHPulldownAppletViewController.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletViewController.h"

@interface MHPulldownAppletViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletViewModel *viewModel;
/// 搜索框容器
@property (nonatomic, readwrite, weak) UIControl *container;
/// searchBar
@property (nonatomic, readwrite, weak) UIButton *searchBar;
/// navBar
@property (nonatomic, readwrite, weak) MHNavigationBar *navBar;
@end

@implementation MHPulldownAppletViewController

@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubviews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
}

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
    @weakify(self);
    
    // 自定义导航栏
    MHNavigationBar *navBar = [MHNavigationBar navigationBar];
    navBar.titleLabel.text = @"小程序";
    navBar.titleLabel.textColor = [UIColor whiteColor];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    /// 搜索框容器
    UIControl *container = [[UIControl alloc] init];
    self.container = container;
    container.mh_height = 74.0f;
    [[container rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@" searchbar did clicked... ");
    }];
    
    /// 搜索框
    NSString *imageName = @"icons_outlined_search_full.svg";
    UIColor *color = MHColorFromHexString(@"A2A1AC");
    UIImage *image = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(16.0, 16.0) tintColor:color];
    
    UIButton *searchBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBar setImage:image forState:UIControlStateNormal];
    [searchBar setImage:image forState:UIControlStateHighlighted];
    searchBar.backgroundColor = MHColorFromHexString(@"#46445B");
    [searchBar setTitleColor:MHColorFromHexString(@"A2A1AC") forState:UIControlStateNormal];
    [searchBar setTitle:@"搜索小程序" forState:UIControlStateNormal];
    searchBar.titleLabel.font = MHRegularFont_16;
    [container addSubview:searchBar];
    self.searchBar = searchBar;
    
    searchBar.cornerRadius = 4.0f;
    searchBar.masksToBounds = YES;
    searchBar.userInteractionEnabled = NO;
    
    [searchBar SG_imagePositionStyle:SGImagePositionStyleDefault spacing:8.0f];
    
    
    self.tableView.tableHeaderView = container;
    self.tableView.tableHeaderView.mh_height = container.mh_height;
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(17.0f, 36.5f, 17.0f, 36.5f));
    }];
}
@end
