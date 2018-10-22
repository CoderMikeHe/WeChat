//
//  MHCameraControlView.h
//  WeChat
//
//  Created by lx on 2018/8/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  照相机控制层

#import <UIKit/UIKit.h>
#import "MHVideoPreviewView.h"


/// 控制层的事件处理
typedef NS_ENUM(NSUInteger, MHCameraControlViewOperationType) {
    MHCameraControlViewOperationTypeSwap = 0,   /// 切换摄像头
    MHCameraControlViewOperationTypeClose,      /// 关闭界面
    MHCameraControlViewOperationTypeCancel,     /// 取消
    MHCameraControlViewOperationTypeEdit,       /// 编辑
    MHCameraControlViewOperationTypeDone,       /// 完成
};



/// 代理

@class MHCameraControlView;

@protocol MHCameraControlViewDelegate <NSObject>

@optional

/// 按钮的操作事件
- (void)cameraControlViewOperationAction:(MHCameraControlView *)controlView operationType:(MHCameraControlViewOperationType)operationType;

@end



@interface MHCameraControlView : UIView

/// previewView
@property (nonatomic , readonly , strong) MHVideoPreviewView *previewView;

/// delegate
@property (nonatomic , readwrite , weak) id <MHCameraControlViewDelegate> delegate;

@end
