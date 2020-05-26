//
//  MHGroupAvatarsView.m
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHGroupAvatarsView.h"
#import "MHGroupAvatarsViewModel.h"

@interface MHGroupAvatarsView ()

/// viewModel
@property (nonatomic, readwrite, strong) MHGroupAvatarsViewModel *viewModel;

@end

@implementation MHGroupAvatarsView

#pragma mark - Public Method
- (void)bindViewModel:(MHGroupAvatarsViewModel *)viewModel {
    self.viewModel = viewModel;
    
    NSInteger count = self.subviews.count;
    NSInteger number = viewModel.itemViewModels.count;
    
    for (NSInteger i = 0; i < count; i++) {
        UIImageView *imageView = (UIImageView *)self.subviews[i];
        imageView.hidden = YES;
        if (i < number) {
            MHGroupAvatarsItemViewModel *vm = viewModel.itemViewModels[i];
            imageView.hidden = NO;
            imageView.frame = vm.frame;
            [imageView yy_setImageWithURL:vm.user.profileImageUrl placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
        }
        
    }
    
}


#pragma mark - Private Method
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 初始化
    [self _setup];
    
    // 创建自控制器
    [self _setupSubviews];
    
    // 布局子控件
    [self _makeSubViewsConstraints];
}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 创建子控件
- (void)_setupSubviews{
    // 3x3
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.hidden = YES;
        [self addSubview:imageView];
    }
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}


@end
