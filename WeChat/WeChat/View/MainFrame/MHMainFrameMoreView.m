//
//  MHMainFrameMoreView.m
//  WeChat
//
//  Created by admin on 2020/5/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameMoreView.h"
// itemView
@interface MHMainFrameMoreItemView : UIButton

@end

@implementation MHMainFrameMoreItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = [MHColorFromHexString(@"#4c4c4c") colorWithAlphaComponent:.5];
        UIImage *imageHigh = [UIImage yy_imageWithColor:color];
        [self setBackgroundImage:imageHigh forState:UIControlStateHighlighted];
    }
    return self;
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.mh_x = 25.0f;
    self.imageView.mh_size = CGSizeMake(24.0f, 24.0f);
    self.imageView.mh_centerY = self.mh_centerY;
    
    self.titleLabel.mh_x = CGRectGetMaxX(self.imageView.frame) + 9.0f;
    self.titleLabel.mh_centerY = self.mh_centerY;
}

@end



@interface MHMainFrameMoreView ()
/// maskView
@property (nonatomic, readwrite, weak) UIControl *maskView;

/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;

/// triangleView
@property (nonatomic, readwrite, weak) UIView *triangleView;

/// menuView
@property (nonatomic, readwrite, weak) UIView *menuView;

@end


@implementation MHMainFrameMoreView

+ (instancetype)moreView {
    return [[MHMainFrameMoreView alloc] init];
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
    /// 蒙版
    UIControl *maskView = [[UIControl alloc] init];
    self.maskView = maskView;
    [self addSubview:maskView];
    
    /// menu 容器
    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    [self addSubview:containerView];
    
    /// 三角形
    UIView *triangleView = [[UIView alloc] init];
    self.triangleView = triangleView;
    [containerView addSubview:triangleView];
    
    /// 三角形
    UIView *menuView = [[UIView alloc] init];
    menuView.cornerRadius = 10.0f;
    menuView.masksToBounds = YES;
    self.menuView = menuView;
    [containerView addSubview:menuView];
    
    NSArray *images = @[@"icons_filled_chats.svg",@"icons_filled_add_friends.svg",@"icons_filled_scan.svg",@"icons_outlined_pay.svg"];
    NSArray *titles = @[@"发起群聊",@"添加朋友",@"扫一扫",@"收付款"];
    
    for (NSInteger i=0; i<titles.count; i++) {
        MHMainFrameMoreItemView *itemView = [[MHMainFrameMoreItemView alloc] init];
        itemView.tag = i;
        UIImage *image = [UIImage mh_svgImageNamed:images[i] targetSize:CGSizeMake(24.0f, 24.0f) tintColor:[UIColor whiteColor]];
        [itemView setImage:image forState:UIControlStateNormal];
        [itemView setTitle:titles[i] forState:UIControlStateNormal];
        [menuView addSubview:itemView];
    }
    
    
    triangleView.backgroundColor = menuView.backgroundColor = MHColorFromHexString(@"#4c4c4c");
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局蒙版
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    /// 布局容器
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.0);
        make.top.equalTo(self).with.offset(.0);
        make.width.mas_equalTo(160.0f);
        make.height.mas_equalTo(6.0f+57*4.0f);
    }];
    
    
    /// 布局三角形
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).with.offset(-14.0);
        make.top.equalTo(self.containerView).with.offset(.0);
        make.width.mas_equalTo(13.0f);
        make.height.mas_equalTo(6.0f);
    }];
    
    /// 布局menuView
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.containerView).with.offset(.0);
        make.top.equalTo(self.triangleView.mas_bottom).with.offset(.0);
    }];
}
@end
