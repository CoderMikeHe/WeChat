//
//  MHHTTPRequest.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  网络服务层 - 请求

#import <Foundation/Foundation.h>
#import "MHURLParameters.h"
#import "RACSignal+MHHTTPServiceAdditions.h"

@interface MHHTTPRequest : NSObject
/// 请求参数
@property (nonatomic, readwrite, strong) MHURLParameters *urlParameters;

/**
 获取请求类
 @param params  参数模型
 @return 请求类
 */
+(instancetype)requestWithParameters:(MHURLParameters *)parameters;

@end



@interface MHHTTPRequest (MHHTTPService)
/// 入队
- (RACSignal *) enqueueResultClass:(Class /*subclass of MHObject*/) resultClass;

@end
