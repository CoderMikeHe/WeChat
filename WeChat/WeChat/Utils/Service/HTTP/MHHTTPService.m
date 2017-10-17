//
//  MHHTTPService.m
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHHTTPService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <CocoaSecurity/CocoaSecurity.h>
#import <MJExtension/MJExtension.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>



/// 用户信息的名称
static NSString * const MHUserDataFileName = @"senba_empty_user.data";
/// 用户数据配置完成
NSString *const MHUserDataConfigureCompleteNotification = @"MHUserDataConfigureCompleteNotification";
/// 用户数据配置完成，取出userInfo 数据的的key
NSString *const MHUserDataConfigureCompleteUserInfoKey = @"MHUserDataConfigureCompleteUserInfoKey";

@interface MHHTTPService ()
/// currentLoginUser
@property (nonatomic, readwrite, strong) MHUser *currentUser;
@end

@implementation MHHTTPService
static id service_ = nil;
#pragma mark -  HTTPService
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.baidu.com/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return service_;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [super allocWithZone:zone];
    });
    return service_;
}
- (id)copyWithZone:(NSZone *)zone {
    return service_;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        /// 配置
        [self _configHTTPService];
    }
    return self;
}

/// config service
- (void)_configHTTPService{
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if DEBUG
    responseSerializer.removesKeysWithNullValues = NO;
#else
    responseSerializer.removesKeysWithNullValues = YES;
#endif
    responseSerializer.readingOptions = NSJSONReadingAllowFragments;
    /// config
    self.responseSerializer = responseSerializer;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    
    self.securityPolicy = securityPolicy;
    /// 支持解析
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                      @"text/json",
                                                      @"text/javascript",
                                                      @"text/html",
                                                      @"text/plain",
                                                      @"text/html; charset=UTF-8",
                                                      nil];
    
    /// 开启网络监测
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            //            [JDStatusBarNotification showWithStatus:@"网络状态未知" styleName:JDStatusBarStyleWarning];
            //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
            NSLog(@"--- 未知网络 ---");
        }else if (status == AFNetworkReachabilityStatusNotReachable) {
            //            [JDStatusBarNotification showWithStatus:@"网络不给力，请检查网络" styleName:JDStatusBarStyleWarning];
            //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
            NSLog(@"--- 无网络 ---");
        }else{
            NSLog(@"--- 有网络 ---");
            //            [JDStatusBarNotification dismiss];
        }
    }];
    [self.reachabilityManager startMonitoring];
}

#pragma mark - User Module
- (void)saveUser:(MHUser *)user
{
    /// 记录用户数据
    self.currentUser = user;
    
    /// 保存
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:MHFilePathFromWeChatDoc(MHUserDataFileName)];
    NSLog(@"Save login user data， the status is %@",status?@"Success...":@"Failure...");
}

- (void)deleteUser:(MHUser *)user{
    /// 删除
    self.currentUser = nil;
//    BOOL status = [MHFileManager removeFile:MHFilePathFromWeChatDoc(MHUserDataFileName)];
//    NSLog(@"Delete login user data ， the status is %@",status?@"Success...":@"Failure...");
}

- (MHUser *)currentUser{
    if (!_currentUser) {
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:MHFilePathFromWeChatDoc(MHUserDataFileName) exception:nil];
    }
    return _currentUser;
}

/// 获取当前用户的id
- (NSString *)currentUserId{
    return [self currentUser].idstr;
}

- (void)loginUser:(MHUser *)user{
    /// 保存用户
    [self saveUser:user];
    
    /// 发送登录成功的通知
    [self postUserDataConfigureCompleteNotification];
    
    /// 设置别名
//    [SBJPushService setAlias];
}

/// 退出登录
- (void)logoutUser
{
    MHUser *currentUser = [self currentUser];
    
    /// 删除别名
//    [SBJPushService deleteAlias];
//
//    /// 删除token
//    [self deleteToken];
    
    /// 删除用户数据
    [self deleteUser:currentUser];
}

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification{
    MHUser *user = [self currentUser];
    [MHNotificationCenter postNotificationName:MHUserDataConfigureCompleteNotification object:nil userInfo:@{MHUserDataConfigureCompleteUserInfoKey:user}];
}

@end
