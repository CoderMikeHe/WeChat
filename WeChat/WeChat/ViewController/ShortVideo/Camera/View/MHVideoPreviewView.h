//
//  MHVideoPreviewView.h
//  WeChat
//
//  Created by lx on 2018/8/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MHVideoPreviewView : UIView

- (CGPoint)captureDevicePointForPoint:(CGPoint)point;

/// 配置捕捉会话管理
- (void)configureCaptureSessionsion:(AVCaptureSession *)session;

/// 获取会话
- (AVCaptureSession*)captureSessionsion;
@end
