//
//  MHNavigationController.m
//  WeChat
//
//  Created by senba on 2017/9/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHNavigationController.h"
#import "MHViewController.h"
@interface MHNavigationController ()
/// 导航栏分隔线
@property (nonatomic , weak , readwrite) UIImageView * navigationBottomLine;
@end

@implementation MHNavigationController

// 第一次使用这个类调用一次
+ (void)initialize{
    // 2.设置UINavigationBar的主题
    [self _setupNavigationBarTheme];
    
    // 3.设置UIBarButtonItem的主题
    [self _setupBarButtonItemTheme];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化
    [self _setup];
}

#pragma mark - 初始化
- (void) _setup
{
    [self _setupNavigationBarBottomLine];
}

// 查询最后一条数据
- (UIImageView *)_findHairlineImageViewUnder:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews){
        UIImageView *imageView = [self _findHairlineImageViewUnder:subview];
        if (imageView){ return imageView; }
    }
    return nil;
}

#pragma mark - 设置导航栏的分割线
- (void)_setupNavigationBarBottomLine{
    //!!!:这里之前设置系统的 navigationBarBottomLine.image = xxx;无效 Why？ 隐藏了系统的 自己添加了一个分割线
    // 隐藏系统的导航栏分割线
    UIImageView *navigationBarBottomLine = [self _findHairlineImageViewUnder:self.navigationBar];
    navigationBarBottomLine.hidden = YES;
    // 添加自己的分割线
    CGFloat navSystemLineH = .5f;
    UIImageView *navSystemLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.mh_height - navSystemLineH, MH_SCREEN_WIDTH, navSystemLineH)];
    // v7.0.0-
//    navSystemLine.backgroundColor = MHColorAlpha(0.0f, 0.0f, 0.0f, 0.1);
    navSystemLine.backgroundColor = [UIColor clearColor];
    [self.navigationBar addSubview:navSystemLine];
    self.navigationBottomLine = navSystemLine;
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void) _setupNavigationBarTheme{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    /// 设置背景
    //!!!: 必须设置为透明  不然布局有问题 ios8以下  会崩溃/ 如果iOS8以下  请再_setup里面 设置透明 self.navigationBar.translucent = YES;
    [appearance setTranslucent:YES]; /// 必须设置YES
    
    // 设置导航栏的样式
    [appearance setBarStyle:UIBarStyleDefault];
    //设置导航栏文字按钮的渲染色
    [appearance setTintColor:MHColorFromHexString(@"#181818")];
    // 设置导航栏的背景渲染色
    [appearance setBarTintColor:[MH_MAIN_BACKGROUNDCOLOR colorWithAlphaComponent:0.65]];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = MHRegularFont(18.0f);
    textAttrs[NSForegroundColorAttributeName] = MHColorFromHexString(@"#181818");
    
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs];
    
    /// 去掉导航栏的阴影图片
    [appearance setShadowImage:[UIImage new]];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)_setupBarButtonItemTheme{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    CGFloat fontSize = 16.0f;
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MHColorFromHexString(@"#181818");
    textAttrs[NSFontAttributeName] = MHRegularFont(fontSize);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [MHColorFromHexString(@"#181818") colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];

    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [MHColorFromHexString(@"#181818") colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}


#pragma mark - Publi Method
/// 显示导航栏的细线
- (void)showNavigationBottomLine { self.navigationBottomLine.hidden = NO; }
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine{ self.navigationBottomLine.hidden = YES; }


/// 能拦截所有push进来的子控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0){
        /// 隐藏底部tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        NSString *title = @"返回";
        
        /// eg: [A push B]
        /// 1.取出当前的控制器的title ， 也就是取出 A.title
        /// CoderMikeHe Fixed: [[self topViewController] navigationItem].title 这样来获取title 而不是[[self topViewController] title]
        title = [[self topViewController] navigationItem].title?:@"返回";
        
        /// 2.判断要被Push的控制器（B）是否是 MHViewController ，
        if ([viewController isKindOfClass:[MHViewController class]]) {
            
            MHViewModel *viewModel = [(MHViewController *)viewController viewModel];
            
            /// 3. 查看backTitle 是否有值
            title = viewModel.backTitle?:title;
        }
        
        // v7.0.0 不需要 title
        
        // 4.这里可以设置导航栏的左右按钮 统一管理方法
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_filled_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:nil target:self selector:@selector(_back)];
    }
    // push
    [super pushViewController:viewController animated:animated];
}
/// 事件处理
- (void)_back{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Override
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.topViewController.prefersStatusBarHidden;
}

@end
