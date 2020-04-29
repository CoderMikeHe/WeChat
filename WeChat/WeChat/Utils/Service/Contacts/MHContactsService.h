//
//  MHContactsService.h
//  WeChat
//
//  Created by 何千元 on 2020/4/29.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

// 处理联系人相关

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHContactsService : NSObject

MHSingletonH(Instance)

// 获取联系人列表
- (RACSignal *)fetchContacts;



@end

NS_ASSUME_NONNULL_END
