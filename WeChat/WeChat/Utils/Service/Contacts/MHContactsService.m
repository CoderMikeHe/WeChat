//
//  MHContactsService.m
//  WeChat
//
//  Created by 何千元 on 2020/4/29.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsService.h"


@interface MHContactsService ()

@end


@implementation MHContactsService

// 单例
MHSingletonM(Instance)

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


/// 获取联系人
-(RACSignal *)fetchContacts {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 读取联系人json
        // 读取路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
        
        // 获取data
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 转换成数据
        NSArray *contatcs = [MHUser modelArrayWithJSON:data];
        
        
        [subscriber sendNext:contatcs];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
