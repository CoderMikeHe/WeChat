//
//  MHURLParameters.h
//  WeChat
//
//  Created by senba on 2017/7/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  网络服务层 -参数

#import <Foundation/Foundation.h>
#import "MHKeyedSubscript.h"
#import "MHHTTPServiceConstant.h"


/// 请求Method
/// GET 请求
#define MH_HTTTP_METHOD_GET @"GET"
/// HEAD
#define MH_HTTTP_METHOD_HEAD @"HEAD"
/// POST
#define MH_HTTTP_METHOD_POST @"POST"
/// PUT
#define MH_HTTTP_METHOD_PUT @"PUT"
/// POST
#define MH_HTTTP_METHOD_PATCH @"PATCH"
/// DELETE
#define MH_HTTTP_METHOD_DELETE @"DELETE"

/// 


///
//+ (NSString *)ver;          // app版本号
//+ (NSString *)token;        // token，默认空字符串
//+ (NSString *)deviceid;     // 设备编号，自行生成
//+ (NSString *)platform;     // 平台 pc,wap,android,iOS
//+ (NSString *)channel;      // 渠道 AppStore
//+ (NSString *)t;            // 当前时间戳

/// 项目额外的配置参数拓展 (PS)开发人员无需考虑
@interface SBURLExtendsParameters : NSObject

/// 类方法
+ (instancetype)extendsParameters;

/// 用户token，默认空字符串
@property (nonatomic, readonly, copy) NSString *token;

/// 设备编号，自行生成
@property (nonatomic, readonly, copy) NSString *deviceid;

/// app版本号
@property (nonatomic, readonly, copy) NSString *ver;

/// 平台 pc,wap,android,iOS
@property (nonatomic, readonly, copy) NSString *platform;

/// 渠道 AppStore
@property (nonatomic, readonly, copy) NSString *channel;

/// 时间戳
@property (nonatomic, readonly, copy) NSString *t;

@end


@interface MHURLParameters : NSObject
/// 路径 （v14/order）
@property (nonatomic, readwrite, strong) NSString *path;
/// 参数列表
@property (nonatomic, readwrite, strong) NSDictionary *parameters;
/// 方法 （POST/GET）
@property (nonatomic, readwrite, strong) NSString *method;
/// 拓展的参数属性 (开发人员不必关心)
@property (nonatomic, readwrite, strong) SBURLExtendsParameters *extendsParameters;

/**
 参数配置（统一用这个方法配置参数） （SBBaseUrl : https://api.cleancool.tenqing.com/）
 https://api.cleancool.tenqing.com/user/info?user_id=100013
 @param method 方法名 （GET/POST/...）
 @param path 文件路径 （user/info）
 @param parameters 具体参数 @{user_id:10013}
 @return 返回一个参数实例
 */
+(instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;
@end
