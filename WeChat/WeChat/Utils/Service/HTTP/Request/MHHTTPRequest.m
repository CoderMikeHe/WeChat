//
//  MHHTTPRequest.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHHTTPRequest.h"
#import "MHHTTPService.h"

@interface MHHTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) MHURLParameters *urlParameters;

@end

@implementation MHHTTPRequest

+(instancetype)requestWithParameters:(MHURLParameters *)parameters{
    return [[self alloc] initRequestWithParameters:parameters];
}

-(instancetype)initRequestWithParameters:(MHURLParameters *)parameters{
    
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}


@end

/// 网络服务层分类 方便MHHTTPRequest 主动发起请求
@implementation MHHTTPRequest (MHHTTPService)
/// 请求数据
-(RACSignal *) enqueueResultClass:(Class /*subclass of MHObject*/) resultClass {
    return [[MHHTTPService sharedInstance] enqueueRequest:self resultClass:resultClass];
}
@end

