//
//  MHCameraControlView.m
//  WeChat
//
//  Created by lx on 2018/8/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHCameraControlView.h"


@interface MHCameraControlView ()

/// previewView
@property (nonatomic , readwrite , strong) MHVideoPreviewView *previewView;

/// 切换摄像头方向
@property (nonatomic , readwrite , weak) UIButton *swapBtn;

/// 关闭按钮
@property (nonatomic , readwrite , weak) UIButton *closeBtn;

/// 返回按钮的父View
@property (nonatomic , readwrite , weak) UIView *cancelView;
/// 模糊效果的View
@property (nonatomic , readwrite , weak) UIVisualEffectView *cancelEffectView;
/// 返回按钮
@property (nonatomic , readwrite , weak) UIButton *cancelBtn;

/// 返回按钮的父View
@property (nonatomic , readwrite , weak) UIView *editView;
/// 模糊效果的View
@property (nonatomic , readwrite , weak) UIVisualEffectView *editEffectView;
/// 编辑按钮
@property (nonatomic , readwrite , weak) UIButton *editBtn;

/// 确定按钮
@property (nonatomic , readwrite , weak) UIButton *doneBtn;



@end


@implementation MHCameraControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 事件处理Or辅助方法
- (void)_btnDidClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraControlViewOperationAction:operationType:)]) {
        [self.delegate cameraControlViewOperationAction:self operationType:sender.tag];
    }
}


#pragma mark - Private Method
- (void)_setup{
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    
    /// 预览层
    MHVideoPreviewView *previewView = [[MHVideoPreviewView alloc] initWithFrame:MH_SCREEN_BOUNDS];
    self.previewView = previewView;
    [self addSubview:previewView];
    
    /// 模糊效果样式
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    
    /// 切换摄像头方向
    UIButton *swapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [swapBtn setBackgroundImage:MHImageNamed(@"voip_flip_camera_icons_60x60") forState:UIControlStateNormal];
    [swapBtn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.swapBtn = swapBtn;
    [self addSubview:swapBtn];
    swapBtn.tag = MHCameraControlViewOperationTypeSwap;
    
    
    /// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:MHImageNamed(@"icon_sight_close_40x40") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = closeBtn;
    [self addSubview:closeBtn];
    closeBtn.tag = MHCameraControlViewOperationTypeClose;
    
    /// 取消
    UIView *cancelView = [[UIView alloc] init];
    cancelView.layer.cornerRadius = 75.0f * .5;
    cancelView.layer.masksToBounds = YES;
    self.cancelView = cancelView;
    [self addSubview:cancelView];
    
    UIVisualEffectView *cancelEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.cancelEffectView = cancelEffectView;
    [cancelView addSubview:cancelEffectView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:MHImageNamed(@"sight_preview_cancel_75x75") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [cancelView addSubview:cancelBtn];
    cancelBtn.tag = MHCameraControlViewOperationTypeCancel;

    /// 编辑
    UIView *editView = [[UIView alloc] init];
    editView.layer.cornerRadius = 75.0f * .5;
    editView.layer.masksToBounds = YES;
    self.editView = editView;
    [self addSubview:editView];
    
    UIVisualEffectView *editEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.editEffectView = editEffectView;
    [editView addSubview:editEffectView];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setBackgroundImage:MHImageNamed(@"EditVideoCameraIconEdit_75x75") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = editBtn;
    [editView addSubview:editBtn];
    editBtn.tag = MHCameraControlViewOperationTypeEdit;
    
    /// 完成按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:MHImageNamed(@"sight_preview_done_75x75") forState:UIControlStateNormal];
    doneBtn.backgroundColor = [UIColor whiteColor];
    doneBtn.layer.cornerRadius = 75.0f * .5;
    doneBtn.layer.masksToBounds = YES;
    [doneBtn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn = doneBtn;
    [self addSubview:doneBtn];
    doneBtn.tag = MHCameraControlViewOperationTypeDone;
    
    /// 默认状态下
    cancelView.hidden = editView.hidden = doneBtn.hidden = YES;
    

    editView.hidden = NO;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    [self.swapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-60);
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.centerX.equalTo(self);
    }];
    [self.editEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    [self.cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.centerY.equalTo(self.editBtn);
    }];
    [self.cancelEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.centerY.equalTo(self.editBtn);
    }];
    
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.centerY.equalTo(self.editBtn);
    }];
    
}

@end
