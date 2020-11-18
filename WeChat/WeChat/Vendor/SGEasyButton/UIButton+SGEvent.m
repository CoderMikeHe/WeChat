//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGEasyButton
//
//  UIButton+SGEvent.m
//  UIButton+SGEvent
//
//  Created by kingsic on 16/10/9.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "UIButton+SGEvent.h"
#import <objc/runtime.h>

@interface UIButton ()
/// 是否忽略点击事件；YES，忽略点击事件，NO，允许点击事件
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIButton (SGEvent)

static const CGFloat SGEventDefaultTimeInterval = 0;

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, @"isIgnoreEvent") boolValue];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @"isIgnoreEvent", @(isIgnoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)SG_eventTimeInterval {
    return [objc_getAssociatedObject(self, @"SG_eventTimeInterval") doubleValue];
}

- (void)setSG_eventTimeInterval:(NSTimeInterval)SG_eventTimeInterval {
    objc_setAssociatedObject(self, @"SG_eventTimeInterval", @(SG_eventTimeInterval), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSEL = @selector(sendAction:to:forEvent:);
        SEL replaceSEL = @selector(SG_sendAction:to:forEvent:);
        Method systemMethod = class_getInstanceMethod(self, systemSEL);
        Method replaceMethod = class_getInstanceMethod(self, replaceSEL);
        
        BOOL isAdd = class_addMethod(self, systemSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
        
        if (isAdd) {
            class_replaceMethod(self, replaceSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            // 添加失败，说明本类中有 replaceMethod 的实现，此时只需要将 systemMethod 和 replaceMethod 的IMP互换一下即可
            method_exchangeImplementations(systemMethod, replaceMethod);
        }
    });
}

- (void)SG_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.SG_eventTimeInterval = self.SG_eventTimeInterval == 0 ? SGEventDefaultTimeInterval : self.SG_eventTimeInterval;
    if (self.isIgnoreEvent){
        return;
    } else if (self.SG_eventTimeInterval >= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.SG_eventTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setIsIgnoreEvent:NO];
        });
    }
    self.isIgnoreEvent = YES;
    [self SG_sendAction:action to:target forEvent:event];
}


@end

