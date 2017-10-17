//
//  MHSearchFriendsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSearchFriendsViewController.h"

@interface MHSearchFriendsViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate>
/// searchBar
@property (nonatomic, readwrite, weak) UISearchBar *searchBar;
/// viewModel
@property (nonatomic, readonly, strong) MHSearchFriendsViewModel *viewModel;
/// tapGr
@property (nonatomic, readwrite, weak) UITapGestureRecognizer *tapGr;
@end

@implementation MHSearchFriendsViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 成为第一响应者
    [self.searchBar becomeFirstResponder];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化
    [self _setup];
    
    /// 初始化子控件
    [self _setupSubViews];
}

#pragma mark - 绑定模型
- (void)bindViewModel{
    [super bindViewModel];
   
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#pragma mark - 初始化
- (void)_setup{
    self.view.backgroundColor = MHColorAlpha(0, 0, 0, .4);
    self.tableView.backgroundColor = [UIColor clearColor];
}
#pragma mark - 初始化子控件
- (void)_setupSubViews
{
    /// 设置玻璃效果
//    [self _setupEffectView];
    
    /// 搜索框
    UISearchBar *searchBar =[[UISearchBar alloc] init];
    self.searchBar = searchBar;
    // 搜索框的占位符
    [self.searchBar setPlaceholder:@"微信号/手机号"];
    // 搜索框指示器`|`的颜色，
    [self.searchBar setTintColor:[UIColor redColor]];
    self.searchBar.barTintColor = [UIColor greenColor];
    // 设置代理
    self.searchBar.delegate = self;
    
    self.searchBar.translucent = YES;
    //改变提示文字颜色
    //首先取出textfield
    UITextField *sbTextField = [self.searchBar valueForKey:@"searchField"];
    sbTextField.font = MHRegularFont_14;
    sbTextField.backgroundColor = [UIColor whiteColor];
    // 输入的颜色
    sbTextField.textColor = [UIColor colorFromHexString:@"#56585f"];
    // 然后取出textField的placeHolder
    UILabel *sbPlaceholderLabel = [sbTextField valueForKey:@"placeholderLabel"];
    sbPlaceholderLabel.textColor = MHColorFromHexString(@"#8E8E92");
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = searchBar;
    
    /// 显示取消按钮
    [self.searchBar setShowsCancelButton:YES];
    // 取出cancelBtn
//    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    /// 设置取消按钮 fix:ViewWillAppear 否则在viewDidLoad设置无效
//    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"];
//    [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor colorFromHexString:@"#9CA1B2"] forState:UIControlStateHighlighted];
//    /// 添加手势
    @weakify(self);
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        [self.searchBar resignFirstResponder];
        [self.viewModel.services dismissViewModelAnimated:YES completion:nil];
    }];
    tapGr.delegate = self;
    [self.tableView addGestureRecognizer:tapGr];
    self.tapGr = tapGr;
    
    
    /// 设置右边取消按钮
//    self.navigationItem.rightBarButtonItem =[UIBarButtonItem mh_systemItemWithTitle:@"取消" titleColor:MHColorFromHexString(@"#06BF04") imageName:nil target:nil selector:nil textType:YES];
//    /// 设置文字偏移,否则取消按钮 挨着搜索框较近，不美观。
//    [self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(8, 0) forBarMetrics:UIBarMetricsDefault];
//    
    
    /// Tips  CoderMikeHe Tips：
    /**
     
     Q：其实UISearchBar，可以设置返回按钮的，但是设置其按钮的文字颜色，需要在ViewWillAppear里面设置，才有效。所以这里，直接采取了用 self.navigationItem.rightBarButtonItem 来代替
     /// 显示取消按钮
     [self.searchBar setShowsCancelButton:YES];
     // 取出cancelBtn
     UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"];
     [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
     /// 设置取消按钮 fix:ViewWillAppear 否则在viewDidLoad设置无效
     UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"];
     [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
     [cancelBtn setTitleColor:[UIColor colorFromHexString:@"#9CA1B2"] forState:UIControlStateHighlighted];
     */

}

/// 添加模糊效果
- (void)_setupEffectView{
    
    UIView *blurEffectView;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // 磨砂效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        // 磨砂视图
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }else{
        
    }
    [self.view insertSubview:blurEffectView atIndex:0];
    [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - UISearchBarDelegate
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    /// 去掉空格
    if ([NSString mh_isEmpty:searchBar.text]) return;
    
    /// 增加搜索条件
//    [self.viewModel.addSearchHistoryCmd execute:searchBar.text];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // fix gesture comflict
    if (self.tapGr == gestureRecognizer && [touch.view isDescendantOfView:self.tableView] && touch.view != self.tableView) {
        return NO;
    }
    return YES;
}
@end
