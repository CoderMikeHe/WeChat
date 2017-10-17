//
//  FBKVOController+MHExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  FBKVOController

#import <KVOController/KVOController.h>

@interface FBKVOController (MHExtension)

- (void)mh_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath block:(FBKVONotificationBlock _Nullable )block;

- (void)mh_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath action:(SEL _Nullable )action;

@end
