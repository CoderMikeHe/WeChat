//
//  NSObject+SBExtension.m
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSObject+SBExtension.h"

@implementation NSObject (SBExtension)

+ (NSInteger) sb_randomNumberWithFrom:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}


- (void)sb_convertNotification:(NSNotification *)notification completion:(void (^ _Nullable)(CGFloat, UIViewAnimationOptions, CGFloat))completion
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
- (BOOL)sb_isStringClass { return [self isKindOfClass:[NSString class]]; }
- (BOOL)sb_isNumberClass { return [self isKindOfClass:[NSNumber class]]; }
- (BOOL)sb_isArrayClass { return [self isKindOfClass:[NSArray class]]; }
- (BOOL)sb_isDictionaryClass { return [self isKindOfClass:[NSDictionary class]]; }
- (BOOL)sb_isStringOrNumberClass { return [self sb_isStringClass] || [self sb_isNumberClass]; }
- (BOOL)sb_isNullOrNil { return !self || [self isKindOfClass:[NSNull class]]; }
- (BOOL)sb_isExist {
    if (self.sb_isNullOrNil) return NO;
    if (self.sb_isStringClass) return (self.sb_stringValueExtension.length>0);
    return YES;
}

/// Get value
- (NSString *)sb_stringValueExtension{
    if ([self sb_isStringClass]) return [(NSString *)self length]? (NSString *)self: @"";
    if ([self sb_isNumberClass]) return [NSString stringWithFormat:@"%@", self];
    return @"";
}


@end
