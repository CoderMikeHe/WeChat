//
//  MHContactsService.m
//  WeChat
//
//  Created by 何千元 on 2020/4/29.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsService.h"

@implementation MHContactsService
MHSingletonM(Instance)

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(RACSignal *)fetchContacts {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
