//
//  NSObject+MHExtension.m
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSObject+MHExtension.h"

@implementation NSObject (MHExtension)

+ (NSInteger) mh_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}


- (void)mh_convertNotification:(NSNotification *)notification completion:(void (^ _Nullable)(CGFloat, UIViewAnimationOptions, CGFloat))completion
{
    // 按钮
    NSDictionary *userInfo = notification.userInfo;
    // 最终尺寸
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 开始尺寸
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 动画时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /// options
    UIViewAnimationOptions options = ([userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 ) | UIViewAnimationOptionBeginFromCurrentState;
   
    /// keyboard height
    CGFloat keyboardH = 0;
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        // up
        keyboardH = endFrame.size.height;
    }else if (endFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        // down
        keyboardH = 0;
    }else{
        // up
        keyboardH = endFrame.size.height;
    }
    /// 回调
    !completion?:completion(duration,options,keyboardH);
}



/// Get class
- (BOOL)mh_isStringClass { return [self isKindOfClass:[NSString class]]; }
- (BOOL)mh_isNumberClass { return [self isKindOfClass:[NSNumber class]]; }
- (BOOL)mh_isArrayClass { return [self isKindOfClass:[NSArray class]]; }
- (BOOL)mh_isDictionaryClass { return [self isKindOfClass:[NSDictionary class]]; }
- (BOOL)mh_isStringOrNumberClass { return [self mh_isStringClass] || [self mh_isNumberClass]; }
- (BOOL)mh_isNullOrNil { return !self || [self isKindOfClass:[NSNull class]]; }
- (BOOL)mh_isExist {
    if (self.mh_isNullOrNil) return NO;
    if (self.mh_isStringClass) return (self.mh_stringValueExtension.length>0);
    return YES;
}

/// Get value
- (NSString *)mh_stringValueExtension{
    if ([self mh_isStringClass]) return [(NSString *)self length]? (NSString *)self: @"";
    if ([self mh_isNumberClass]) return [NSString stringWithFormat:@"%@", self];
    return @"";
}


@end
