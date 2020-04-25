//
//  MHHomePageViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHHomePageViewController.h"
#import "MHNavigationController.h"
#import "MHMainFrameViewController.h"
#import "MHContactsViewController.h"
#import "MHDiscoverViewController.h"
#import "MHProfileViewController.h"
@interface MHHomePageViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHHomePageViewModel *viewModel;
@end

@implementation MHHomePageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /// 初始化所有的子控制器
    [self _setupAllChildViewController];
    
    /// set delegate
    self.tabBarController.delegate = self;
    
    // 适配 iOS 13.0+ : - [设置UITabBarItem上title颜色(适配iOS 13)](https://www.jianshu.com/p/46755b8087e0)
    if (@available(iOS 13.0, *)) {
        // iOS 13以上
        self.tabBarController.tabBar.tintColor = WXGlobalPrimaryTintColor;
        self.tabBarController.tabBar.unselectedItemTintColor = MHColorFromHexString(@"#191919");
    }
    
}

#pragma mark - 初始化所有的子视图控制器
- (void)_setupAllChildViewController{
    NSArray *titlesArray = @[@"微信", @"通讯录", @"发现", @"我"];
    NSArray *imageNamesArray = @[@"icons_outlined_chats.svg",
                                 @"icons_outlined_contacts.svg",
                                 @"icons_outlined_discover.svg",
                                 @"icons_outlined_me.svg"];
    NSArray *selectedImageNamesArray = @[@"icons_filled_chats.svg",
                                         @"icons_filled_contacts.svg",
                                         @"icons_filled_discover.svg",
                                         @"icons_filled_me.svg"];
    
    /// 微信会话层
    UINavigationController *mainFrameNavigationController = ({
        MHMainFrameViewController *mainFrameViewController = [[MHMainFrameViewController alloc] initWithViewModel:self.viewModel.mainFrameViewModel];
        
        MHTabBarItemTagType tagType = MHTabBarItemTagTypeMainFrame;
        /// 配置
        [self _configViewController:mainFrameViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        /// 添加到导航栏的栈底控制器
        [[MHNavigationController alloc] initWithRootViewController:mainFrameViewController];
    });
    
    /// 通讯录
    UINavigationController *contactsNavigationController = ({
        MHContactsViewController *contactsViewController = [[MHContactsViewController alloc] initWithViewModel:self.viewModel.contactsViewModel];
        
        MHTabBarItemTagType tagType = MHTabBarItemTagTypeContacts;
        /// 配置
        [self _configViewController:contactsViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[MHNavigationController alloc] initWithRootViewController:contactsViewController];
    });
    
    /// 发现
    UINavigationController *discoverNavigationController = ({
        MHDiscoverViewController *discoverViewController = [[MHDiscoverViewController alloc] initWithViewModel:self.viewModel.discoverViewModel];
        
        MHTabBarItemTagType tagType = MHTabBarItemTagTypeDiscover;
        /// 配置
        [self _configViewController:discoverViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[MHNavigationController alloc] initWithRootViewController:discoverViewController];
    });
    
    /// 我的
    UINavigationController *profileNavigationController = ({
        MHProfileViewController *profileViewController = [[MHProfileViewController alloc] initWithViewModel:self.viewModel.profileViewModel];
        
        MHTabBarItemTagType tagType = MHTabBarItemTagTypeProfile;
        /// 配置
        [self _configViewController:profileViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[MHNavigationController alloc] initWithRootViewController:profileViewController];
    });
    
    /// 添加到tabBarController的子视图
    self.tabBarController.viewControllers = @[ mainFrameNavigationController, contactsNavigationController, discoverNavigationController, profileNavigationController ];
    
    /// 配置栈底
    [MHSharedAppDelegate.navigationControllerStack pushNavigationController:mainFrameNavigationController];
}

#pragma mark - 配置ViewController
- (void)_configViewController:(UIViewController *)viewController imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title itemTag:(MHTabBarItemTagType)tagType {
    
    UIImage *image = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(25.0, 25.0)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.tag = tagType;
    
    UIImage *selectedImage = [UIImage mh_svgImageNamed:selectedImageName targetSize:CGSizeMake(25.0, 25.0) tintColor:WXGlobalPrimaryTintColor];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    viewController.tabBarItem.title = title;
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#191919"),
                                 NSFontAttributeName:MHRegularFont_10};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:WXGlobalPrimaryTintColor,
                                   NSFontAttributeName:MHRegularFont_10};
    [viewController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


//#pragma mark - UITabBarControllerDelegate
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    /// 需要判断是否登录
//    if ([[self.viewModel.services client] isLogin]) return YES;
//    
//    MHTabBarItemTagType tagType = viewController.tabBarItem.tag;
//    
//    switch (tagType) {
//        case MHTabBarItemTagTypeHome:
//        case MHTabBarItemTagTypeConsign:
//            return YES;
//            break;
//        case MHTabBarItemTagTypeMessage:
//        case MHTabBarItemTagTypeProfile:
//        {
//            @weakify(self);
//            [[self.viewModel.services client] checkLogin:^{
//                @strongify(self);
//                self.tabBarController.selectedViewController = viewController;
//                [self tabBarController:tabBarController didSelectViewController:viewController];
//            } cancel:NULL];
//            return NO;
//        }
//            break;
//    }
//    return NO;
//}
//
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [MHSharedAppDelegate.navigationControllerStack popNavigationController];
    [MHSharedAppDelegate.navigationControllerStack pushNavigationController:(UINavigationController *)viewController];
}

@end
