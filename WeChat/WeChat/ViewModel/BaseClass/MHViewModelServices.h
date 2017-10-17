//
//  MHViewModelServices.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  视图模型服务层测协议 （导航栏操作的服务层 + 网络的服务层 ）

#import <Foundation/Foundation.h>
#import "MHNavigationProtocol.h"
#import "MHHTTPService.h"
@protocol MHViewModelServices <NSObject,MHNavigationProtocol>
/// A reference to MHHTTPService instance.
/// 全局通过这个Client来请求数据，处理用户信息
@property (nonatomic, readonly, strong) MHHTTPService *client;
@end
