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



/**
 * 知识点
 //- (RACSignal *)replayLast 就是用Capacity为1的RACReplaySubject来替换- (RACSignal *)replay的`subject。
 其作用是使后来订阅者只收到最后的历史值。
 //- (RACSignal *)replayLazily和- (RACSignal *)replay的区别就是replayLazily会在第一次订阅的时候才订阅sourceSignal。
 //  replay、replayLast、replayLazily的区别 ReactiveCocoa提供了这三个简便的方法允许多个订阅者订阅一个信号，却不会重复执行订阅代码，并且能给新加的订阅者提供订阅前的值。
 replay和replayLast使信号变成热信号，且会提供所有值(-replay) 或者最新的值(-replayLast) 给订阅者。
 replayLazily 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
 *
 */
/// The Http request error domain
NSString *const MHHTTPServiceErrorDomain = @"MHHTTPServiceErrorDomain";
/// 请求成功，但statusCode != 0
NSString *const MHHTTPServiceErrorResponseCodeKey = @"MHHTTPServiceErrorResponseCodeKey";


NSString * const MHHTTPServiceErrorRequestURLKey = @"MHHTTPServiceErrorRequestURLKey";
NSString * const MHHTTPServiceErrorHTTPStatusCodeKey = @"MHHTTPServiceErrorHTTPStatusCodeKey";
NSString * const MHHTTPServiceErrorDescriptionKey = @"MHHTTPServiceErrorDescriptionKey";
NSString * const MHHTTPServiceErrorMessagesKey = @"MHHTTPServiceErrorMessagesKey";





/// 连接服务器失败 default
NSInteger const MHHTTPServiceErrorConnectionFailed = 668;
NSInteger const MHHTTPServiceErrorJSONParsingFailed = 669;

NSInteger const MHHTTPServiceErrorBadRequest = 670;
NSInteger const MHHTTPServiceErrorRequestForbidden = 671;
/// 服务器请求失败
NSInteger const MHHTTPServiceErrorServiceRequestFailed = 672;
NSInteger const MHHTTPServiceErrorSecureConnectionFailed = 673;



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
        service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://live.9158.com/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
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
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /// 安全策略
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
- (void)logoutUser{
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



#pragma mark - Request
-(RACSignal *) enqueueRequest:(MHHTTPRequest *) request resultClass:(Class /*subclass of MHObject*/) resultClass{
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:-1 userInfo:nil]];
    
    @weakify(self);
    
   /// 覆盖manager请求序列化
//    self.requestSerializer = [self _requestSerializerWithRequest:request];
    
    /// 发起请求
    /// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。 这里传进去的参数，不是parameters而是之前通过
    /// urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;穿进去的参数
    return [[[self enqueueRequestWithPath:request.urlParameters.path parameters:request.urlParameters.parameters method:request.urlParameters.method]
             reduceEach:^RACStream *(NSURLResponse *response, NSDictionary * responseObject){
                 @strongify(self);
                 /// 请求成功 这里解析数据
                 return [[self parsedResponseOfClass:resultClass fromJSON:responseObject]
                         map:^(id parsedResult) {
                             MHHTTPResponse *parsedResponse = [[MHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedResult];
                             NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
                             return parsedResponse;
                         }];
             }]
            concat];
}
/// 请求数据
- (RACSignal *)enqueueRequestWithPath:(NSString *)path parameters:(id)parameters method:(NSString *)method{
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
        
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        /// 获取请求任务
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSDictionary * responseObject, NSError *error) {
            /// MLGB
            id o = [[YYCache sharedCache] objectForKey:@"xxoo"];
            if (MHObjectIsNil(o)) {
                [[YYCache sharedCache] setObject:responseObject forKey:@"xxoo"];
            }
            responseObject = o;
            if (0) {
                NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
                [self HTTPRequestLog:task body:parameters error:parseError];
                [subscriber sendError:parseError];
            } else {
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                /// 在这里判断数据是否正确
                /// 判断
                NSInteger statusCode = [responseObject[MHHTTPServiceResponseCodeKey] integerValue];
                if (statusCode == MHHTTPResponseCodeSuccess) {
                    
//                    NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)response;
//                    /// 存储token
//                    NSString *token = [[[httpUrlResponse allHeaderFields] valueForKey:MHHTTPRequestTokenKey] mh_stringValueExtension];
//                    [self saveToken:token];

                    [self HTTPRequestLog:task body:parameters error:nil];
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response , responseObject)];
                    [subscriber sendCompleted];
                }else{
                    if (statusCode == MHHTTPResponseCodeNotLogin) {
                        /// 需要登录
//                        [self login:^{
//                            /// 这里需要重新配置序列化
//                            self.requestSerializer = [self _requestSerializerWithRequest:[MHHTTPRequest requestWithParameters:[MHURLParameters urlParametersWithMethod:method path:path parameters:parameters]]];
//                            /// 重新发起请求
//                            [[self enqueueRequestWithPath:path parameters:parameters method:method] subscribe:subscriber];
//                        } cancel:^{
//                            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                            userInfo[MHHTTPServiceErrorResponseCodeKey] = @(statusCode);
//                            NSString *msgTips = responseObject[MHHTTPServiceResponseMsgKey];
//#if defined(DEBUG)||defined(_DEBUG)
//                            msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
//#else
//                            msgTips = MHStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~"; /// 发布模式
//#endif
//                            userInfo[MHHTTPServiceErrorMessagesKey] = msgTips;
//                            if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
//                            if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
//                            NSError *requestError = [NSError errorWithDomain:MHHTTPServiceErrorDomain code:statusCode userInfo:userInfo];
//                            [self HTTPRequestLog:task body:parameters error:requestError];
//                            [subscriber sendError:requestError];
//                        }];
                    }else{
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        userInfo[MHHTTPServiceErrorResponseCodeKey] = @(statusCode);
                        NSString *msgTips = responseObject[MHHTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                        msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
#else
                        msgTips = MHStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";/// 发布模式
#endif
                        userInfo[MHHTTPServiceErrorMessagesKey] = msgTips;
                        if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                        if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                        NSError *requestError = [NSError errorWithDomain:MHHTTPServiceErrorDomain code:statusCode userInfo:userInfo];
                        [self HTTPRequestLog:task body:parameters error:requestError];
                        [subscriber sendError:requestError];
                    }
                }
            }
        }];
        /// 开启请求任务
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal
             replayLazily]
            setNameWithFormat:@"-enqueueRequestWithPath: %@ parameters: %@ method: %@", path, parameters , method];
}






#pragma mark - Upload
- (RACSignal *)enqueueUploadRequest:(MHHTTPRequest *)request resultClass:(Class)resultClass fileDatas:(NSArray<NSData *> *)fileDatas name:(NSString *)name mimeType:(NSString *)mimeType{
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:-1 userInfo:nil]];
    /// 断言
    NSAssert(MHStringIsNotEmpty(name), @"name is empty: %@", name);
    
    @weakify(self);
    
    /// 覆盖manager 请求序列化
    self.requestSerializer = [self _requestSerializerWithRequest:request];
    
    /// 发起请求
    /// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。 这里传进去的参数，不是parameters而是之前通过
    /// urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;穿进去的参数
    return [[[self enqueueUploadRequestWithPath:request.urlParameters.path parameters:request.urlParameters.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSInteger count = fileDatas.count;
        for (int i = 0; i< count; i++) {
            /// 取出fileData
            NSData *fileData = fileDatas[i];
            
            /// 断言
            NSAssert([fileData isKindOfClass:NSData.class], @"fileData is not an NSData class: %@", fileData);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            
            static NSDateFormatter *formatter = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                formatter = [[NSDateFormatter alloc] init];
            });
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"senba_empty_%@_%zd.jpg", dateString , i];
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:MHStringIsNotEmpty(mimeType)?mimeType:@"application/octet-stream"];
        }
    }]
             reduceEach:^RACStream *(NSURLResponse *response, NSDictionary * responseObject){
                 @strongify(self);
                 /// 请求成功 这里解析数据
                 return [[self parsedResponseOfClass:resultClass fromJSON:responseObject]
                         map:^(id parsedResult) {
                             MHHTTPResponse *parsedResponse = [[MHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedResult];
                             NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
                             return parsedResponse;
                         }];
             }]
            concat];;
}


- (RACSignal *)enqueueUploadRequestWithPath:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block{
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        
        NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        
        __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
                [self HTTPRequestLog:task body:parameters error:parseError];
                [subscriber sendError:parseError];
            } else {
                
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                
                /// 在这里判断数据是否正确
                /// 判断
                NSInteger statusCode = [responseObject[MHHTTPServiceResponseCodeKey] integerValue];
                
                if (statusCode == MHHTTPResponseCodeSuccess) {
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response , responseObject)];
                    [subscriber sendCompleted];
                }else{
                    
                    if (statusCode == MHHTTPResponseCodeNotLogin) {
                        
                        /// 需要登录
//                        [self login:^{
//                            /// 这里需要重新配置序列化
//                            self.requestSerializer = [self _requestSerializerWithRequest:[MHHTTPRequest requestWithParameters:[MHURLParameters urlParametersWithMethod:@"POST" path:path parameters:parameters]]];
//                            /// 重新发起请求
//                            [self enqueueUploadRequestWithPath:path parameters:parameters constructingBodyWithBlock:block];
//                        } cancel:^{
//                            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                            userInfo[MHHTTPServiceErrorResponseCodeKey] = @(statusCode);
//                            NSString *msgTips = responseObject[MHHTTPServiceResponseMsgKey];
//#if defined(DEBUG)||defined(_DEBUG)
//                            msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
//#else
//                            msgTips = MHStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";  /// 发布模式
//#endif
//                            userInfo[MHHTTPServiceErrorMessagesKey] = msgTips;
//                            if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
//                            if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
//                            [subscriber sendError:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:statusCode userInfo:userInfo]];
//                        }];
                    }else{
                        
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        userInfo[MHHTTPServiceErrorResponseCodeKey] = @(statusCode);
                        NSString *msgTips = responseObject[MHHTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                        msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
#else
                        msgTips = MHStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";  /// 发布模式
#endif
                        userInfo[MHHTTPServiceErrorMessagesKey] = msgTips;
                        if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                        if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                        [subscriber sendError:[NSError errorWithDomain:MHHTTPServiceErrorDomain code:statusCode userInfo:userInfo]];
                    }
                }
                
            }
        }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal
             replayLazily]
            setNameWithFormat:@"-enqueueUploadRequestWithPath: %@ parameters: %@", path, parameters];
}


#pragma mark Parsing (数据解析)
- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    return [NSError errorWithDomain:MHHTTPServiceErrorDomain code:MHHTTPServiceErrorJSONParsingFailed userInfo:userInfo];
}

/// 解析数据
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(NSDictionary *)responseObject {
    /// 必须是MHObject的子类 且 最外层responseObject必须是字典
    NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:MHObject.class]));
    
    /// 这里主要解析的是 data:对应的数据
    responseObject = responseObject[MHHTTPServiceResponseDataKey];
    
    /// 解析
    return [RACSignal createSignal:^ id (id<RACSubscriber> subscriber) {
        /// 解析字典
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (resultClass == nil) {
                [subscriber sendNext:JSONDictionary];
                return;
            }
            /// 这里继续取出数据 data{"list":[]}
            NSArray * JSONArray = JSONDictionary[MHHTTPServiceResponseDataListKey];
            if ([JSONArray isKindOfClass:[NSArray class]]) {
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:JSONArray];
                /// 这里还需要解析是否是MHObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 MHObject
                    NSAssert([parsedObject isKindOfClass:MHObject.class], @"Parsed model object is not an MHObject: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
                
            }else{
                /// 字典转模型
                MHObject *parsedObject = [resultClass yy_modelWithDictionary:JSONDictionary];
                if (parsedObject == nil) {
                    // Don't treat "no class found" errors as real parsing failures.
                    // In theory, this makes parsing code forward-compatible with
                    // API additions.
                    // 模型解析失败
                    NSError *error = [NSError errorWithDomain:@"" code:2222 userInfo:@{}];
                    [subscriber sendError:error];
                    return;
                }
                
                /// 确保解析出来的类 也是 BaseModel
                NSAssert([parsedObject isKindOfClass:MHObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                /// 发送数据
                [subscriber sendNext:parsedObject];
            }
        };
        
        if ([responseObject isKindOfClass:NSArray.class]) {
            
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            }else{
                /// 数组 保证数组里面装的是同一种 NSDcitionary
                for (NSDictionary *JSONDictionary in responseObject) {
                    if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                        [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                        return nil;
                    }
                }
                    
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:responseObject];
                
                /// 这里还需要解析是否是MHObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 BaseModel
                    NSAssert([parsedObject isKindOfClass:MHObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            /// 解析字典
            parseJSONDictionary(responseObject);
            [subscriber sendCompleted];
        } else if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        return nil;
    }];
}

#pragma mark - Error Handling
/// 请求错误解析
- (NSError *)_errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(NSDictionary *)responseObject error:(NSError *)error {
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is MHHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = MHHTTPServiceErrorConnectionFailed;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode>0) {
        if (httpFirstCode==4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(408)~"; /// 调试模式
#else
                errorDesc = @"请求超时，请稍后再试~";      /// 发布模式
#endif
            }else{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",HTTPCode];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";      /// 发布模式
#endif
            }
        }else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
#if defined(DEBUG)||defined(_DEBUG)
            errorDesc = [NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",HTTPCode];                      /// 调试模式
#else
            errorDesc = @"服务器出错了，请稍后重试~";       /// 发布模式
#endif
            
        }else if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }else{
        if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    switch (HTTPCode) {
        case 400:{
            errorCode = MHHTTPServiceErrorBadRequest;           /// 请求失败
            break;
        }
        case 403:{
            errorCode = MHHTTPServiceErrorRequestForbidden;     /// 服务器拒绝请求
            break;
        }
        case 422:{
            errorCode = MHHTTPServiceErrorServiceRequestFailed; /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",error.code];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";        /// 发布模式
#endif
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:
                        errorCode = MHHTTPServiceErrorSecureConnectionFailed; /// 建立安全连接出错了
                        break;
                    case NSURLErrorTimedOut:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
#else
                        errorDesc = @"请求超时，请稍后再试~";        /// 发布模式
#endif
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"网络开小差了，请稍后重试(-1009)~"; /// 调试模式
#else
                        errorDesc = @"网络开小差了，请稍后重试~";        /// 发布模式
#endif
                        break;
                    }
                }
            }
    }
    userInfo[MHHTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[MHHTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[MHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    return [NSError errorWithDomain:MHHTTPServiceErrorDomain code:errorCode userInfo:userInfo];
}



#pragma mark - 打印请求日志
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:params error:(NSError *)error {
    NSLog(@">>>>>>>>>>>>>>>>>>>>>👇 REQUEST FINISH 👇>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"Request%@=======>:%@", error?@"失败":@"成功", task.currentRequest.URL.absoluteString);
    NSLog(@"requestBody======>:%@", params);
    NSLog(@"requstHeader=====>:%@", task.currentRequest.allHTTPHeaderFields);
    NSLog(@"response=========>:%@", task.response);
    NSLog(@"error============>:%@", error);
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<");
}











#pragma mark - Parameter 签名 MD5 生成一个 sign ，这里请根据实际项目来定
/// 基础的请求参数
-(NSMutableDictionary *)_parametersWithRequest:(MHHTTPRequest *)request{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /// 模型转字典
    NSDictionary *extendsUrlParams = [request.urlParameters.extendsParameters mj_keyValues].copy;
    if ([extendsUrlParams count]) {
        [parameters addEntriesFromDictionary:extendsUrlParams];
    }
    if ([request.urlParameters.parameters count]) {
        [parameters addEntriesFromDictionary:request.urlParameters.parameters];
    }
    return parameters;
}

/// 带签名的请求参数
-(NSString *)_signWithParameters:(NSDictionary *) parameters {
    /// 按照ASCII码排序
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *kvs = [NSMutableArray array];
    for (id key in sortedKeys) {
        /// value 为 empty 跳过
        if(MHObjectIsNil(parameters[key])) continue;
        NSString * value = [parameters[key] mh_stringValueExtension];
        if (MHObjectIsNil(value)||!MHStringIsNotEmpty(value)) continue;
        value = [value sb_removeBothEndsWhitespaceAndNewline];
        value = [value sb_URLEncoding];
        [kvs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    /// 拼接私钥
    NSString *paramString = [kvs componentsJoinedByString:@"&"];
    NSString *keyValue = MHHTTPServiceKeyValue;
    NSString *signedString = [NSString stringWithFormat:@"%@&%@=%@",paramString,MHHTTPServiceKey,keyValue];
    
    /// md5
    return [CocoaSecurity md5:signedString].hexLower;
}

/// 序列化
- (AFHTTPRequestSerializer *)_requestSerializerWithRequest:(MHHTTPRequest *) request{
    /// 获取基础参数（参数+拓展参数）
    NSMutableDictionary *parameters = [self _parametersWithRequest:request];
    /// 获取带签名的参数
    NSString *sign = [self _signWithParameters:parameters];
    /// 赋值
    parameters[MHHTTPServiceSignKey] = [sign length]?sign:@"";
    /// 请求序列化
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    /// 配置请求头
    for (NSString *key in parameters) {
        NSString *value = [[parameters[key] mh_stringValueExtension] copy];
        if (value.length==0) continue;
        /// value只能是字符串，否则崩溃
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    return requestSerializer;
}
@end
