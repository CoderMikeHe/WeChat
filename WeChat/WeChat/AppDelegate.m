//
//  AppDelegate.m
//  WeChat
//
//  Created by senba on 2017/9/4.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "AppDelegate.h"
#import "MHHomePageViewController.h"
#import "MHAccountLoginViewModel.h"
#import "MHNewFeatureViewModel.h"
#import "MHBootLoginViewModel.h"


#if defined(DEBUG)||defined(_DEBUG)
#import <JPFPSStatus/JPFPSStatus.h>
//#import "SBDebugTouchView.h"
//#import <FBMemoryProfiler/FBMemoryProfiler.h>
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
//#import "CacheCleanerPlugin.h"
//#import "RetainCycleLoggerPlugin.h"
#endif
@interface AppDelegate ()

/// APP管理的导航栏的堆栈
@property (nonatomic, readwrite, strong) MHNavigationControllerStack *navigationControllerStack;
/// APP的服务层
@property (nonatomic, readwrite, strong) MHViewModelServicesImpl *services;

@end

@implementation AppDelegate
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 初始化UI之前配置
    [self _configureApplication:application initialParamsBeforeInitUI:launchOptions];
    
    // Config Service
    self.services = [[MHViewModelServicesImpl alloc] init];
    // Config Nav Stack
    self.navigationControllerStack = [[MHNavigationControllerStack alloc] initWithServices:self.services];
    // Configure Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 重置rootViewController
    [self.services resetRootViewModel:[self _createInitialViewModel]];
    // 让窗口可见
    [self.window makeKeyAndVisible];
    
    /// 初始化UI后配置
    [self _configureApplication:application initialParamsAfterInitUI:launchOptions];
    
    
#if defined(DEBUG)||defined(_DEBUG)
    /// 调试模式
    [self _configDebugModelTools];
#endif
    
    // Save the application version info. must write last
    [[NSUserDefaults standardUserDefaults] setValue:MH_APP_VERSION forKey:MHApplicationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}



#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions
{
    /// 显示状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /// 配置键盘
    [self _configureKeyboardManager];
    
    /// 配置文件夹
    [self _configureApplicationDirectory];
    
    /// 配置FMDB
    [self _configureFMDB];
}

/// 配置文件夹
- (void)_configureApplicationDirectory
{
    /// 创建doc
    [MHFileManager createDirectoryAtPath:MHWeChatDocDirPath()];
    /// 创建cache
    [MHFileManager createDirectoryAtPath:MHWeChatCacheDirPath()];
    
    NSLog(@"MHWeChatDocDirPath is [ %@ ] \n MHWeChatCacheDirPath is [ %@ ]" , MHWeChatDocDirPath() , MHWeChatCacheDirPath());
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置FMDB
- (void) _configureFMDB
{
//    [[FMDatabaseQueue sharedInstance] inDatabase:^(FMDatabase *db) {
//        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:SBApplicationVersionKey];
//        if (![version isEqualToString:SB_APP_VERSION]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"senba_empty_1.0.0" ofType:@"sql"];
//            NSString *sql  = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            /// 执行文件
//            if (![db executeStatements:sql]) {
//                SBLogLastError(db);
//            }
//        }
//    }];
}

#pragma mark - 在初始化UI之后配置
- (void)_configureApplication:(UIApplication *)application initialParamsAfterInitUI:(NSDictionary *)launchOptions
{
    /// 配置ActionSheet
    [LCActionSheet mh_configureActionSheet];
    
    /// 预先配置平台信息
//    [SBUMengService configureUMengPreDefinePlatforms];
    
    @weakify(self);
    /// 监听切换根控制器的通知
    [[MHNotificationCenter rac_addObserverForName:MHSwitchRootViewControllerNotification object:nil] subscribeNext:^(NSNotification * note) {
        /// 这里切换根控制器
        @strongify(self);
        // 重置rootViewController
        MHSwitchRootViewControllerFromType fromType = [note.userInfo[MHSwitchRootViewControllerUserInfoKey] integerValue];
        NSLog(@"fromType is  %zd" , fromType);
        /// 切换根控制器
        [self.services resetRootViewModel:[self _createInitialViewModel]];
    }];
    
    /// 配置H5
//    [SBConfigureManager configure];
}

#pragma mark - 调试(DEBUG)模式下的工具条
- (void)_configDebugModelTools
{
    /// 显示FPS
    [[JPFPSStatus sharedInstance] open];
    
    /// 打开调试按钮，每次重启就会开启
//    [[SBDebugTouchView sharedInstance] open];
}



#pragma mark - 创建根控制器
- (MHViewModel *)_createInitialViewModel {
    // The user has logged-in.
    NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:MHApplicationVersionKey];
    /// 版本不一样就先走 新特性界面
    if (![version isEqualToString:MH_APP_VERSION]){
        return [[MHNewFeatureViewModel alloc] initWithServices:self.services params:nil];
    }else{
        /// 这里判断一下
        if ([SAMKeychain rawLogin] && self.services.client.currentUser) { /// 有账号+有用户数据
            /// 已经登录，跳转到主页
            return [[MHHomePageViewModel alloc] initWithServices:self.services params:nil];
        }else if(self.services.client.currentUser){ /// 没账号+有用户数据
            /// 跳转到账户登录页面
            return [[MHAccountLoginViewModel alloc] initWithServices:self.services params:nil];
        }else{
            /// 第一次使用微信
            return [[MHBootLoginViewModel alloc] initWithServices:self.services params:nil];
        }
    }
}

#pragma mark- 获取appDelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}




















































- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
