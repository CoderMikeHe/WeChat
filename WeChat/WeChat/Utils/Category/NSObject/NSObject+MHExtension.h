//
//  NSObject+MHExtension.h
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MHExtension)
/// 获取 [from to] 之间的数据
+ (NSInteger) mh_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to;

/// 根据获取到的
- (void)mh_convertNotification:(NSNotification *_Nullable)notification completion:(void (^ __nullable)(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH))completion;


#pragma mark - Get..
/// Get class
- (BOOL)mh_isStringClass;
- (BOOL)mh_isNumberClass;
- (BOOL)mh_isArrayClass;
- (BOOL)mh_isDictionaryClass;
- (BOOL)mh_isStringOrNumberClass;
- (BOOL)mh_isNullOrNil;
- (BOOL)mh_isExist;

/// Get value
- (NSString *_Nullable)mh_stringValueExtension;


@end
