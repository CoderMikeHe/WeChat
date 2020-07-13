//
//  MHBouncyBallsView.m
//  WeChat
//
//  Created by admin on 2020/7/2.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHBouncyBallsView.h"
#import "MHBouncyBallsViewModel.h"
#import "YYTimer.h"

@interface MHBouncyBallsView ()
/// viewModel
@property (nonatomic, readwrite, strong) MHBouncyBallsViewModel *viewModel;

/// leftBall
@property (nonatomic, readwrite, weak) UIView *leftBall;
/// centerBall
@property (nonatomic, readwrite, weak) UIView *centerBall;
/// rightBall
@property (nonatomic, readwrite, weak) UIView *rightBall;

/// lastOffset 上一次偏移量
@property (nonatomic, readwrite, assign) CGFloat lastOffset;
/// stepValue
@property (nonatomic, readwrite, assign) CGFloat stepValue;
/// lastState
@property (nonatomic, readwrite, assign) MHRefreshState lastState;

/// Timer
@property (nonatomic, readwrite, strong) YYTimer *timer;

@end

@implementation MHBouncyBallsView

+(instancetype)bouncyBallsView {
    return [[self alloc] init];
}


- (void)bindViewModel:(MHBouncyBallsViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    /// Fixed bug: distinctUntilChanged 不需要，否则某些场景认为没变化 实际上变化了
    RACSignal *signal = [RACObserve(self.viewModel, offsetInfo) skip:1];
    [signal subscribeNext:^(NSDictionary *dictionary) {
        @strongify(self);
        
        CGFloat offset = [dictionary[@"offset"] doubleValue];
        MHRefreshState state = [dictionary[@"state"] doubleValue];
        BOOL animate = [dictionary[@"animate"] boolValue];
        
        if (animate) {
            
            if (!self.timer && !self.timer.isValid && self.lastOffset > MHPulldownAppletCriticalPoint0) {
                NSTimeInterval interval = .05f;
                CGFloat count = .3/interval;
                self.stepValue = self.lastOffset/count;
                self.timer = [YYTimer timerWithTimeInterval:interval target:self selector:@selector(_timerValueChanged:) repeats:YES];
            }
            
        } else {
            /// 记录上一次数据
            self.lastOffset = offset;
            ///
            [self _handleOffset:dictionary];
        }
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
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
#pragma mark - 辅助方法
- (void)_handleOffset:(NSDictionary *)dictionary {
    
    CGFloat offset = [dictionary[@"offset"] doubleValue];
    MHRefreshState state = [dictionary[@"state"] doubleValue];
    
    ///
    if (state == MHRefreshStateRefreshing) {
        self.alpha = .0f;
    }else {
        self.alpha = 1.0f;
    }
 
    // 中间点相关
    CGFloat scale = 0.0;
    CGFloat alphaC = 0;
    
    // 右边点相关
    CGFloat translateR = 0.0;
    CGFloat alphaR = 0;
    
    // 左边点相关
    CGFloat translateL = 0.0;
    CGFloat alphaL = 0;
    
    if (offset > MHPulldownAppletCriticalPoint3){
        /// 超过这个 统一是 将自身隐藏
        self.alpha = .0f;
        
    } else if (offset > MHPulldownAppletCriticalPoint2) {
        // 第四阶段 1 - 0
        CGFloat step = 1.0 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
        double alpha = 1 - step * (offset - MHPulldownAppletCriticalPoint2);
        alpha = MAX(.0f, alpha);
        
        // 中间点阶段III: 保持scale 为1
        alphaC = alpha;
        scale = 1;
        
        // 右边点阶段III: 平移到最右侧
        alphaR = alpha;
        translateR = 16;
        
        // 左边点阶段III: 平移到最左侧
        alphaL = alpha;
        translateL = -16;
    } else if (offset > MHPulldownAppletCriticalPoint1) {
        CGFloat delta = MHPulldownAppletCriticalPoint2 - MHPulldownAppletCriticalPoint1;
        CGFloat deltaOffset = offset - MHPulldownAppletCriticalPoint1;
        
        // 中间点阶段II: 中间点缩小：2 -> 1
        CGFloat stepC = 1 / delta;
        alphaC = 1;
        scale = 2 - stepC * deltaOffset;
        
        // 右边点阶段II: 慢慢平移 0 -> 16
        CGFloat stepR = 16.0 / delta;
        alphaR = 1;
        translateR = stepR * deltaOffset;
        
        // 左边点阶段II: 慢慢平移 0 -> -16
        CGFloat stepL = -16.0 / delta;
        alphaL = 1;
        translateL = stepL * deltaOffset;
    } else if (offset > MHPulldownAppletCriticalPoint0) {
        CGFloat delta = MHPulldownAppletCriticalPoint1 - MHPulldownAppletCriticalPoint0;
        CGFloat deltaOffset = offset - MHPulldownAppletCriticalPoint0;
        
        // 中间点阶段I: 中间点放大：0 -> 2
        CGFloat step = 2 / delta;
        alphaC = 1;
        scale = 0 + step * deltaOffset;
    }
    
    self.centerBall.alpha = alphaC;
    self.centerBall.transform = CGAffineTransformMakeScale(scale, scale);
    
    self.leftBall.alpha = alphaL;
    self.leftBall.transform = CGAffineTransformMakeTranslation(translateL, 0);
    
    self.rightBall.alpha = alphaR;
    self.rightBall.transform = CGAffineTransformMakeTranslation(translateR, 0);
}

/// 定时器为
- (void)_timerValueChanged:(YYTimer *)timer
{
    self.lastOffset -= self.stepValue;
    if (self.lastOffset <= 0) {
        [timer invalidate];
        self.timer = nil;
    }
    CGFloat offset = MAX(0, self.lastOffset);
    [self _handleOffset: @{@"offset" : @(offset), @"state": @(MHRefreshStateIdle), @"animate": @NO}];
}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.alpha = .0f;
}

/// 创建子控件
- (void)_setupSubviews{

    /// 三个球
    UIView *leftBall = [self _generateOneBall];
    self.leftBall = leftBall;
    [self addSubview:leftBall];
    
    UIView *rightBall = [self _generateOneBall];
    self.rightBall = rightBall;
    [self addSubview:rightBall];
    
    UIView *centerBall = [self _generateOneBall];
    self.centerBall = centerBall;
    [self addSubview:centerBall];
}

/// 生成一个球
- (UIView *)_generateOneBall {
    UIView *ball = [[UIView alloc] init];
    ball.backgroundColor = MHColorFromHexString(@"#b7b7b7");
    ball.cornerRadius = 3.0f;
    ball.masksToBounds = YES;
    ball.alpha = .0f;
    return ball;
}


/// 布局子控件
- (void)_makeSubViewsConstraints{

    [@[self.leftBall, self.rightBall, self.centerBall] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.center.equalTo(self);
    }];
}


@end
