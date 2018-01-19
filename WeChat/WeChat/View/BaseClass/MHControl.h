//
//  MHControl.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGestureRecognizer.h"

@class MHControl;

@interface MHControl : UIView
/// 图片
@property (nonatomic, readwrite , strong) UIImage *image;

/// 点击回调
@property (nonatomic, readwrite, copy) void (^touchBlock)(MHControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
/// 长按回调
@property (nonatomic, readwrite, copy) void (^longPressBlock)(MHControl *view, CGPoint point);
@end
