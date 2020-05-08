//
//  MHSearchVoiceInputView.m
//  WeChat
//
//  Created by admin on 2020/5/8.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchVoiceInputView.h"

@interface MHSearchVoiceInputView ()

/// voiceInputBtn
@property (nonatomic, readwrite, weak) UIButton *voiceInputBtn;

/// tipsLabel
@property (nonatomic, readwrite, weak) UILabel *tipsLabel;
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
    // 修改背景颜色
    sender.backgroundColor = WXGlobalPrimaryTintColor;
    // 修改图标颜色
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:MHColorFromHexString(@"#ffffff")];
    [sender setImage:image forState:UIControlStateNormal|UIControlStateHighlighted];
}

- (void)_btnTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 25.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
    } else {
        // UIControlEventTouchUpInside
    }
    
    // 修改背景颜色
    sender.backgroundColor = [UIColor whiteColor];
    // 修改图标颜色
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:MHColorFromHexString(@"#666666")];
    [sender setImage:image forState:UIControlStateNormal];
}

- (void)_btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 25.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit
        } else {
            // UIControlEventTouchDragOutside
            // 修改背景颜色
            sender.backgroundColor = [UIColor whiteColor];
            // 修改图标颜色
            UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:MHColorFromHexString(@"#666666")];
            [sender setImage:image forState:UIControlStateNormal|UIControlStateHighlighted];
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
        } else {
            // UIControlEventTouchDragInside
            // 修改背景颜色
            sender.backgroundColor = WXGlobalPrimaryTintColor;
            // 修改图标颜色
            UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:MHColorFromHexString(@"#ffffff")];
            [sender setImage:image forState:UIControlStateNormal|UIControlStateHighlighted];
        }
    }
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
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_voiceinput_white.svg" targetSize:CGSizeMake(36.0, 36.0) tintColor:MHColorFromHexString(@"#666666")];
    [voiceInputBtn setImage:image forState:UIControlStateNormal];
    voiceInputBtn.backgroundColor = [UIColor whiteColor];
    voiceInputBtn.cornerRadius = 57 * 0.5;
    voiceInputBtn.masksToBounds = YES;
    [self addSubview:voiceInputBtn];
    self.voiceInputBtn = voiceInputBtn;
    
    
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
}

@end
