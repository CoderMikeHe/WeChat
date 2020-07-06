//
//  MHBouncyBallsView.m
//  WeChat
//
//  Created by admin on 2020/7/2.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHBouncyBallsView.h"

@interface MHBouncyBallsView ()

/// container
@property (nonatomic, readwrite, weak) UIView *container;

@end

@implementation MHBouncyBallsView

+(instancetype)bouncyBallsView {
    return [[self alloc] init];
}

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


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 创建子控件
- (void)_setupSubviews{
    /// 容器
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [self addSubview:container];
    
    /// 
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}


@end
