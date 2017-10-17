//
//  NSObject+SBExtension.h
//  SenbaEmpty
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SBExtension)
/// 获取 [from to] 之间的数据
+ (NSInteger) sb_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to;

/// 根据获取到的
- (void)sb_convertNotification:(NSNotification *_Nullable)notification completion:(void (^ __nullable)(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH))completion;


#pragma mark - Get..
/// Get class
- (BOOL)sb_isStringClass;
- (BOOL)sb_isNumberClass;
- (BOOL)sb_isArrayClass;
- (BOOL)sb_isDictionaryClass;
- (BOOL)sb_isStringOrNumberClass;
- (BOOL)sb_isNullOrNil;
- (BOOL)sb_isExist;

/// Get value
- (NSString *_Nullable)sb_stringValueExtension;


@end
