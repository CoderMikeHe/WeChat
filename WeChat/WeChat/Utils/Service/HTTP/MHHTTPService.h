//
//  MHHTTPService.h
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+RACSupport.h"
#import "RACSubscriber+AFProgressCallbacks.h"
#import "MHHTTPRequest.h"
#import "MHHTTPResponse.h"
#import "MHURLConfigure.h"
#import "MHUser.h"


// The domain for all errors originating in MHHTTPService.
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorDomain ;
///
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorHTTPPResponseStatusCodeKey;
FOUNDATION_EXTERN NSString *const MHHTTPServiceErrorHTTPPResponseMsgKey ;

// A user info key associated with the NSURL of the request that failed.
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorRequestURLKey ;
// A user info key associated with an NSNumber, indicating the HTTP status code
// that was returned with the error.
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorHTTPStatusCodeKey ;
/// The descriptive message returned from the API, e.g., "Validation Failed".
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorDescriptionKey ;
/// An array of specific message strings returned from the API, e.g.,
/// "No commits between joshaber:master and joshaber:feature".
FOUNDATION_EXTERN NSString * const MHHTTPServiceErrorMessagesKey ;





/// 连接服务器失败 default
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorConnectionFailed ;

FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorJSONParsingFailed ;
// The request was invalid (HTTP error 400).
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorBadRequest ;
// The server is refusing to process the request because of an
// authentication-related issue (HTTP error 403).
//
// Often, this means that there have been too many failed attempts to
// authenticate. Even a successful authentication will not work while this error
// code is being returned. The only recourse is to stop trying and wait for
// a bit.
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorRequestForbidden ;
// The server refused to process the request (HTTP error 422)
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorServiceRequestFailed ;
// There was a problem establishing a secure connection, although the server is
// reachable.
FOUNDATION_EXTERN NSInteger const MHHTTPServiceErrorSecureConnectionFailed ;


/// 用户数据配置完成
FOUNDATION_EXTERN NSString *const SBUserDataConfigureCompleteNotification;
/// 用户数据配置完成，取出userInfo 数据的的key
FOUNDATION_EXTERN NSString *const SBUserDataConfigureCompleteUserInfoKey;

@interface MHHTTPService : AFHTTPSessionManager
/// 单例
+(instancetype) sharedInstance;
/// 存储用户
- (void)saveUser:(MHUser *)user;

/// 删除用户
- (void)deleteUser:(MHUser *)user;

/// 获取当前用户
- (MHUser *)currentUser;

/// 获取当前用户的id
- (NSString *)currentUserId;

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification;

/// 是否登录
- (BOOL)isLogin;

/// 用户登录
- (void)loginUser:(MHUser *)user;

/// 退出登录
- (void)logoutUser;
@end


/// 请求类
@interface MHHTTPService (Request)

/// 1. 使用须知：后台返回数据的保证为👇固定格式 且`data:{}`必须为`字典`或者`NSNull`;
/// {
///    code：0,
///    msg: "",
///    data:{
///    }
/// }
/// 这个方法返回的 signal 将会 send `MHHTTPResponse`这个实例，`parsedResult`就是对应键data对应的值， 如果你想获得里面的parsedResult实例，请使用以下方法
/// [[self enqueueRequest:request resultClass:SBUser.class] sb_parsedResults];
/// 这样取出来的就是 SBUser对象

/// 2.使用方法如下
/*
 /// 1. 配置参数
 SBKeyedSubscript *subscript = [SBKeyedSubscript subscript];
 subscript[@"page"] = @1;
 
 /// 2. 配置参数模型
 SBURLParameters *paramters = [SBURLParameters urlParametersWithMethod:@"GET" path:SUProduct parameters:subscript.dictionary];
 
 /// 3. 创建请求
 /// 3.1 resultClass 传入对象必须得是 MHObject的子类
 /// 3.2 resultClass 传入nil ，那么回调回来的值就是，服务器返回来的数据
 [[[[MHHTTPRequest requestWithParameters:paramters]
 enqueueResultClass:[SBGoodsData class]]
 sb_parsedResults]
 subscribeNext:^(SBGoodsData * goodsData) {
 /// 成功回调
 
 } error:^(NSError *error) {
 /// 失败回调
 
 } completed:^{
 /// 完成
 
 }];
 
 */

/**
 Enqueues a request to be sent to the server.
 This will automatically fetch a of the given endpoint. Each object
 from each page will be sent independently on the returned signal, so
 subscribers don't have to know or care about this pagination behavior.
 
 @param request config the request
 @param resultClass A subclass of `MHObject` that the response data should be returned as,
 and will be accessible from the `parsedResult`
 @return Returns a signal which will send an instance of `MHHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
-(RACSignal *)enqueueRequest:(MHHTTPRequest *) request
                 resultClass:(Class /*subclass of MHObject*/) resultClass;


/**
 用来上传多个文件流，也可以上传单个文件
 
 @param request MHHTTPRequest
 @param resultClass 要转化出来的请求结果且必须是 `MHObject`的子类，否则Crash
 @param fileDatas 要上传的 文件数据，数组里面必须是装着` NSData ` 否则Crash
 @param name  这个是服务器的`资源文件名`，这个服务器会给出具体的数值，不能传nil 否则 Crach
 @param mimeType http://www.jianshu.com/p/a3e77751d37c 如果传nil ，则会传递 application/octet-stream
 @return Returns a signal which will send an instance of `MHHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
- (RACSignal *)enqueueUploadRequest:(MHHTTPRequest *) request
                        resultClass:(Class /*subclass of MHObject*/) resultClass
                          fileDatas:(NSArray <NSData *> *)fileDatas
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType;
@end
