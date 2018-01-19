//
//  MHMomentBackgroundView.m
//  WeChat
//
//  Created by senba on 2018/1/18.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHMomentBackgroundView.h"

@interface MHMomentBackgroundView ()

@end


@implementation MHMomentBackgroundView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 初始化
    [self _setup];
    
    /// 初始化控件
    [self _setupSubViews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 初始化
        [self _setup];
        
        /// 初始化控件
        [self _setupSubViews];
    }
    return self;
}


#pragma mark - Private Method
- (void)_setup{
    
}

- (void)_setupSubViews{
    
    /// 单击手势
    
    
    /// 长按手势
    
    
}

@end
