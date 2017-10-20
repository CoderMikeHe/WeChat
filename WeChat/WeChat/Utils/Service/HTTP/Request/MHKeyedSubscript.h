//
//  MHKeyedSubscript.h
//  WeChat
//
//  Created by senba on 2017/7/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  参数

#import <Foundation/Foundation.h>

@interface MHKeyedSubscript : NSObject
/// 类方法
+ (instancetype) subscript;
/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *) dict;
-(instancetype)initWithDictionary:(NSDictionary *) dict;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// 转换为字典
- (NSDictionary *)dictionary;
@end
