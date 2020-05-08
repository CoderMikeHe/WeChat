//
//  MHSearchVoiceInputView.m
//  WeChat
//
//  Created by admin on 2020/5/8.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchVoiceInputView.h"


typedef NS_ENUM(NSUInteger, MHButtonTouchState) {
    MHButtonTouchStateDefault = 0, // 默认
    MHButtonTouchStateInside,      // 内部
    MHButtonTouchStateOutside,     // 外部
};


@interface MHSearchVoiceInputView ()

/// voiceInputBtn
@property (nonatomic, readwrite, weak) UIButton *voiceInputBtn;

/// tipsLabel
@property (nonatomic, readwrite, weak) UILabel *tipsLabel;


/// rippleView
@property (nonatomic, readwrite, weak) UIView *rippleView;
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

- (void)_btnTouchDown:(UIButton *)sender {
    // touch inside
    [self _configVoiceInputButtonStyle:MHButtonTouchStateInside];
}

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
}

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
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.autoreverses = YES;
    //removedOnCompletion为NO保证app切换到后台动画再切回来时动画依然执行
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(1.4);
    [self.rippleView.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
}

//不使用时记得移除动画
- (void)voiceCircleStop {
    [self.layer removeAllAnimations];
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
    
    [self.rippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(84, 84));
        make.center.equalTo(self.voiceInputBtn);
    }];
}

@end
