//
//  MHCameraViewController.m
//  WeChat
//
//  Created by lx on 2018/8/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHCameraViewController.h"
#import "MHVideoPreviewView.h"
#import "MHCameraControlView.h"
#import "PKShortVideoRecorder.h"
@interface MHCameraViewController ()<PKShortVideoRecorderDelegate,MHCameraControlViewDelegate>

/// controlView
@property (nonatomic , readwrite , weak) MHCameraControlView *controlView;

@property (nonatomic, strong) PKShortVideoRecorder *recorder;

@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic , readwrite , weak) UIImageView *preImageView;

@end

@implementation MHCameraViewController

- (void)dealloc{
    MHDealloc;
    /**
     *  销毁 设备旋转 通知
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
    /**
     *  结束 设备旋转通知
     *
     *  @return return value description
     */
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
    
    //开始预览摄像头工作
    [self.recorder startRunning];
    
    
    UIImageView *preImageView = [[UIImageView alloc] init];
    [self.view addSubview:preImageView];
    self.preImageView = preImageView;
    self.preImageView.hidden = YES;;
    
    [self.preImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(MH_SCREEN_WIDTH);
        make.left.right.equalTo(self.view);
        
    }];
    
    
    
    /**
     *  开始生成 设备旋转 通知
     */
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    /// 屏幕锁定则无效
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleDeviceOrientationDidChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil
//     ];
    
    /// 屏幕锁定则无效
    

    
    
    
    
    

    
    
}






- (void)handleDeviceOrientationDidChange
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    
    
    
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
    
}

#pragma mark - 事件处理Or辅助方法
/// 关闭相机界面
- (void)_closeCamera{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)_editSource{
    @weakify(self);
    
    self.preImageView.hidden = YES;
    
    NSLog(@"---- Before -------");
    [self handleDeviceOrientationDidChange];
    [self.recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
        @strongify(self);
        
        NSLog(@"---- After -------");
        [self handleDeviceOrientationDidChange];
        /// 竖屏拍照： UIImageOrientationRight
        self.preImageView.hidden = NO;
        NSLog(@"imageOrientation --- %d" , image.imageOrientation);
        self.preImageView.image = image;
        
    }];
}

#pragma mark - MHCameraControlViewDelegate
- (void)cameraControlViewOperationAction:(MHCameraControlView *)controlView operationType:(MHCameraControlViewOperationType)operationType{
    switch (operationType) {
        case MHCameraControlViewOperationTypeSwap:
        {
            //
        }
            break;
        case MHCameraControlViewOperationTypeClose:
        {
            [self _closeCamera];
        }
            break;
        case MHCameraControlViewOperationTypeEdit:
        {
            // 编辑
            [self _editSource];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PKShortVideoRecorderDelegate
- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder{
    MHLogFunc;
}
- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder{
    MHLogFunc;
}
- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error{
    MHLogFunc;
}



#pragma mark - 初始化
- (void)_setup{
    
    
    
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
    
    self.outputSize = CGSizeMake(320, 240);
    self.outputFilePath = path;
    
    // 创建视频录制对象
    self.recorder = [[PKShortVideoRecorder alloc] initWithOutputFilePath:self.outputFilePath outputSize:self.outputSize];
    // 通过代理回调
    self.recorder.delegate = self;
    
    
    // controlView
    MHCameraControlView *controlView = [[MHCameraControlView alloc] initWithFrame:MH_SCREEN_BOUNDS];
    controlView.delegate = self;
    self.controlView = controlView;
    [self.view addSubview:controlView];
    /// 设置实时预览
    if (self.recorder.captureSession) {
        [controlView.previewView configureCaptureSessionsion:self.recorder.captureSession];
    }
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Setter & Getter


#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden { return YES; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }
@end
