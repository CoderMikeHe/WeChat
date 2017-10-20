//
//  MHHTTPServiceConstant.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#ifndef MHHTTPServiceConstant_h
#define MHHTTPServiceConstant_h

/// 服务器相关
#define MHHTTPRequestTokenKey @"token"

/// 私钥key
#define MHHTTPServiceKey  @"privatekey"
/// 私钥Value
#define MHHTTPServiceKeyValue @"5f558dac2aaa27b716e1bdbf3da7dcd0"

/// 签名key
#define MHHTTPServiceSignKey @"sign"

/// 服务器返回的三个固定字段
/// 状态码key
#define MHHTTPServiceResponseCodeKey @"code"
/// 消息key
#define MHHTTPServiceResponseMsgKey    @"msg"
/// 数据data
#define MHHTTPServiceResponseDataKey   @"data"
/// 数据data{"list":[]}
#define MHHTTPServiceResponseDataListKey   @"list"

#endif /* MHHTTPServiceConstant_h */
