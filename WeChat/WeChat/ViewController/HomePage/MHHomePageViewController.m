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
    
}

#pragma mark - 初始化所有的子视图控制器
- (void)_setupAllChildViewController{
    NSArray *titlesArray = @[@"微信", @"通讯录", @"发现", @"我"];
    NSArray *imageNamesArray = @[@"tabbar_mainframe_25x23",
                                 @"tabbar_contacts_27x23",
                                 @"tabbar_discover_23x23",
                                 @"tabbar_me_23x23"];
    NSArray *selectedImageNamesArray = @[@"tabbar_mainframeHL_25x23",
                                         @"tabbar_contactsHL_27x23",
                                         @"tabbar_discoverHL_23x23",
                                         @"tabbar_meHL_23x23"];
    
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
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.tag = tagType;
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    viewController.tabBarItem.title = title;
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#929292"),
                                 NSFontAttributeName:MHRegularFont_10};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#09AA07"),
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
    NSLog(@"viewController   %@  %zd",viewController,viewController.tabBarItem.tag);
    [MHSharedAppDelegate.navigationControllerStack popNavigationController];
    [MHSharedAppDelegate.navigationControllerStack pushNavigationController:(UINavigationController *)viewController];
}

@end
