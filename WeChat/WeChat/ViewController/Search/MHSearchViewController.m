//
//  MHSearchViewController.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewController.h"
#import "MHSearchTypeView.h"
#import "MHSearchOfficialAccountsView.h"
#import "MHSearchMusicView.h"

@interface MHSearchViewController ()
/// scrollView
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;

/// searchTypeView
@property (nonatomic, readwrite, weak) MHSearchTypeView *searchTypeView;

/// officialAccountsView
@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsView *officialAccountsView;

/// MusicView
@property (nonatomic, readwrite, strong) MHSearchMusicView *musicView;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchViewModel *viewModel;

@end

@implementation MHSearchViewController

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
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[self.viewModel.searchTypeSubject deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        MHSearchType searchType = x.integerValue;
        [self _configureSearchView:searchType];
    }];
}

#pragma mark - 事件处理Or辅助方法
- (void)_configureSearchView:(MHSearchType)type {
    self.view.userInteractionEnabled = NO;
    // 更新布局
    [UIView animateWithDuration:0.25 animations:^{
        
        switch (type) {
            case MHSearchTypeOfficialAccounts:
            {
                self.officialAccountsView.alpha = 1.0;
                self.musicView.alpha = .0;
            }
                break;
            case MHSearchTypeMusic:
            {
                self.officialAccountsView.alpha = .0;
                self.musicView.alpha = 1.0;
            }
                break;
            case MHSearchTypeSticker:
            {
                self.officialAccountsView.alpha = .0;
                self.musicView.alpha = .0;
            }
                break;
            default:
            {
                self.officialAccountsView.alpha = .0;
                self.musicView.alpha = .0;
            }
                break;
        }
        
        
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /// containerView
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    self.containerView = containerView;
    
    // searchTypeView
    MHSearchTypeView *searchTypeView = [MHSearchTypeView searchTypeView];
    self.searchTypeView = searchTypeView;
    [searchTypeView bindViewModel:self.viewModel.searchTypeViewModel];
    [containerView addSubview:searchTypeView];
    
    // OfficialAccountsView
    MHSearchOfficialAccountsView *officialAccountsView = [MHSearchOfficialAccountsView officialAccountsView];
    self.officialAccountsView = officialAccountsView;
    officialAccountsView.alpha = .0;
    [containerView addSubview:officialAccountsView];
    
    // musicView
    MHSearchMusicView *musicView = [MHSearchMusicView musicView];
    self.musicView = musicView;
    musicView.alpha = .0;
    [containerView addSubview:musicView];
    
    // 设置背景色
    containerView.backgroundColor = searchTypeView.backgroundColor = self.view.backgroundColor;
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    // 设置view
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// 设置contentSize
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
    }];
    
    /// 布局 
    [self.searchTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).with.offset(39.0);
    }];
    
    
    [self.officialAccountsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.containerView);
    }];
}

@end
