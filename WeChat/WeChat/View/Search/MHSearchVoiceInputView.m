//
//  MHSearchVoiceInputView.m
//  WeChat
//
//  Created by admin on 2020/5/8.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchVoiceInputView.h"
#import "IFlyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
typedef NS_ENUM(NSUInteger, MHButtonTouchState) {
    MHButtonTouchStateDefault = 0, // 默认
    MHButtonTouchStateInside,      // 内部
    MHButtonTouchStateOutside,     // 外部
};


@interface MHSearchVoiceInputView ()<IFlySpeechRecognizerDelegate>

/// voiceInputBtn
@property (nonatomic, readwrite, weak) UIButton *voiceInputBtn;

/// tipsLabel
@property (nonatomic, readwrite, weak) UILabel *tipsLabel;


/// rippleView
@property (nonatomic, readwrite, weak) UIView *rippleView;



// 不带界面的识别对象
@property (nonatomic, readwrite, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

/// resultStringFromJson
@property (nonatomic, readwrite, copy) NSString *resultStringFromJson;


@end


@implementation MHSearchVoiceInputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

/// 构造方法
+ (instancetype)voiceInputView {
    return [[self alloc] init];
}


/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark - Setter & Getter




#pragma mark - 辅助方法
/// 开始录音
- (void)_startListening {
    [self.iFlySpeechRecognizer cancel];
    
    

    BOOL ret = [self.iFlySpeechRecognizer startListening];
    
    if (ret) {
        
        NSLog(@"开始录入成功...");
        
    }else{
        NSLog(@"开始录入失败...");
    }
}

/// 停止录音
- (void)_stopListening {
    [self.iFlySpeechRecognizer stopListening];
}


// 按下 开始语音录入
- (void)_btnTouchDown:(UIButton *)sender {
    // touch inside
    [self _configVoiceInputButtonStyle:MHButtonTouchStateInside];
    
    [self voiceCircleRun];
    
//    [self _startListening];
}


// 弹起 结束语音录入
- (void)_btnTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 27.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
    } else {
        // UIControlEventTouchUpInside
    }
    
    [self _configVoiceInputButtonStyle:MHButtonTouchStateDefault];
    [self voiceCircleStop];
//    [self _stopListening];
}

// 拖拽
- (void)_btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 27.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit
        } else {
            // UIControlEventTouchDragOutside
            [self _configVoiceInputButtonStyle:MHButtonTouchStateOutside];
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
        } else {
            // UIControlEventTouchDragInside
            [self _configVoiceInputButtonStyle:MHButtonTouchStateInside];
        }
    }
}

/// 配置按钮
- (void)_configVoiceInputButtonStyle: (MHButtonTouchState)state {
    
    UIColor *backgroundColor = [UIColor whiteColor];
    UIColor *tintColor = MHColorFromHexString(@"#666666");
    
    if (state == MHButtonTouchStateInside) {
        backgroundColor = WXGlobalPrimaryTintColor;
        tintColor = MHColorFromHexString(@"#CAEED8");
    } else if(state == MHButtonTouchStateOutside){
        backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        tintColor = MHColorFromHexString(@"#587C66");
    }
    
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:tintColor];
    [self.voiceInputBtn setImage:image forState:UIControlStateNormal];
    [self.voiceInputBtn setImage:image forState:UIControlStateHighlighted];
    self.voiceInputBtn.backgroundColor = backgroundColor;
}

- (void)voiceCircleRun {
    [UIView animateWithDuration:0.25 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        self.rippleView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:1.0 delay:0.25 usingSpringWithDamping:.5 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           self.rippleView.transform = CGAffineTransformMakeScale(1.9, 1.9);
       } completion:^(BOOL finished) {
           
       }];
    }];
}

//不使用时记得移除动画
- (void)voiceCircleStop {
   [UIView animateWithDuration:0.25 delay:0.25 options: UIViewAnimationOptionCurveEaseIn animations:^{
       self.rippleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
   } completion:^(BOOL finished) {
      
   }];
}


#pragma mark - IFlySpeechRecognizerDelegate
- (void) onCompleted:(IFlySpeechError *) error {
    NSString *text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
    NSLog(@" onCompleted   %@", text);
}
// 识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * _result =[NSString stringWithFormat:@"%@", resultString];
    
    NSLog(@"onResults  %@  %d  %@", results, isLast, _result);
    
    //持续拼接语音内容
    self.resultStringFromJson = [self.resultStringFromJson stringByAppendingString:[ISRDataHelper stringFromJson:resultString]];
    NSLog(@"self.resultStringFromJson = %@",self.resultStringFromJson);
}

// 停止录音回调
-(void)onEndOfSpeech{
//    self.isStartRecord = YES;
    NSLog(@"onEndOfSpeech");
}

// 开始录音回调
-(void)onBeginOfSpeech{
        NSLog(@"onbeginofspeech");
}

// 音量回调函数 0-30
-(void)onVolumeChanged:(int)volume{
//    NSLog(@"onVolumeChanged  %d", volume);
}

// 会话取消回调
-(void)onCancel
{
        NSLog(@"取消本次录音");
}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}


/// 创建子控件
- (void)_setupSubviews{
    
    @weakify(self);
    /// 按钮
    UIButton *voiceInputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceInputBtn.cornerRadius = 57 * 0.5;
    voiceInputBtn.masksToBounds = YES;
    [self addSubview:voiceInputBtn];
    self.voiceInputBtn = voiceInputBtn;
    
    [self _configVoiceInputButtonStyle:MHButtonTouchStateDefault];
    
    // 关于 UIBUtton 事件详解 👍
    // https://stackoverflow.com/questions/14340122/uicontroleventtouchdragexit-triggers-when-100-pixels-away-from-uibutton/30320206#30320206
    // https://www.jianshu.com/p/dffcf43a4141
    // https://blog.csdn.net/heng615975867/article/details/39321081
    // touchdown
    [voiceInputBtn addTarget:self action:@selector(_btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    // to get the touch up event
    [voiceInputBtn addTarget:self action:@selector(_btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [voiceInputBtn addTarget:self action:@selector(_btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    // to get the drag event
    [voiceInputBtn addTarget:self action:@selector(_btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [voiceInputBtn addTarget:self action:@selector(_btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    
    /// tipsLabel
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = MHRegularFont_12;
    tipsLabel.textColor = MHColorFromHexString(@"#a6a6a6");
    tipsLabel.numberOfLines = 1;
    tipsLabel.text = @"按住 说话";
    [self addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    
    // rippleView
    UIView *rippleView = [[UIView alloc] init];
    rippleView.backgroundColor = MHColorFromHexString(@"#c6e3d2");
    self.rippleView = rippleView;
    rippleView.cornerRadius = 57 * 0.5;
    rippleView.masksToBounds = YES;
    [self insertSubview:rippleView belowSubview:voiceInputBtn];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    [self.voiceInputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(24.0f);
        make.size.mas_equalTo(CGSizeMake(57, 57));
        make.centerX.equalTo(self);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceInputBtn.mas_bottom).with.offset(5.0f);
        make.centerX.equalTo(self);
    }];
    
    // 常规状态时111
    [self.rippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(57, 57));
        make.center.equalTo(self.voiceInputBtn);
    }];
}

#pragma mark - Lazy Load
-(IFlySpeechRecognizer *)iFlySpeechRecognizer
{
    if (!_iFlySpeechRecognizer) {
        //创建语音识别对象
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        //设置识别参数
        //设置为听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path 是录音文件名，设置 value 为 nil 或者为空取消保存，默认保存目录在 Library/cache 下。
        [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        //设置最长录音时间:60秒
        [_iFlySpeechRecognizer setParameter:@"-1" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置语音后端点:后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音
        [_iFlySpeechRecognizer setParameter:@"10000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置语音前端点:静音超时时间，即用户多长时间不说话则当做超时处理
        [_iFlySpeechRecognizer setParameter:@"5000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"2000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
        //Set microphone as audio source
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        // Set result type
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //设置代理
        _iFlySpeechRecognizer.delegate = self;
    }
    return _iFlySpeechRecognizer;
}


@end
