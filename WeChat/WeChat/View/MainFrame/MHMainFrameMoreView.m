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
@interface MHMainFrameMoreItemView ()

// 分割线
@property (nonatomic, readwrite, weak) UIView *divider;

@end
@implementation MHMainFrameMoreItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = MHRegularFont_17;
        
        UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:.1];
        UIImage *imageHigh = [UIImage yy_imageWithColor:color];
        [self setBackgroundImage:imageHigh forState:UIControlStateHighlighted];
        
        
        // 分割线
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = MHColorFromHexString(@"#5d5d5c");
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.mh_x = 25.0f;
    self.imageView.mh_size = CGSizeMake(24.0f, 24.0f);
    self.imageView.mh_y = (self.mh_height - 24.0f) *.5f;
    
    self.titleLabel.mh_x = CGRectGetMaxX(self.imageView.frame) + 9.0f;
    self.titleLabel.mh_y = (self.mh_height - self.titleLabel.mh_height) *.5f;
    
    CGFloat dividerX = self.titleLabel.mh_x;
    CGFloat dividerY = self.mh_height - .8f;
    CGFloat dividerW = self.mh_width - dividerX;
    CGFloat dividerH = 0.8f;
    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
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

#pragma mark - Public Method
- (void)show {
    self.containerView.alpha = .0;
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.alpha = 1.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)hideWithCompletion:(void (^)())completion {
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.alpha = .0;
    } completion:^(BOOL finished) {
        !completion?:completion();
    }];
}


#pragma mark - Event
- (void)_maskViewDidClick:(UIColor *)sender {
    !self.maskAction?:self.maskAction();
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
    [maskView addTarget:self action:@selector(_maskViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /// menu 容器
    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    [self addSubview:containerView];
    
    
    /// 三角形 13 x 6
    UIView *triangleView = [[UIView alloc] init];
    self.triangleView = triangleView;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 6)];
    [path addLineToPoint:CGPointMake(13, 6)];
    [path addLineToPoint:CGPointMake(6.5, 0)];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    triangleView.layer.mask = layer;
    [containerView addSubview:triangleView];
    
    /// 菜单
    UIView *menuView = [[UIView alloc] init];
    menuView.cornerRadius = 4.0f;
    menuView.masksToBounds = YES;
    self.menuView = menuView;
    [containerView addSubview:menuView];
    
    NSArray *images = @[@"icons_filled_chats.svg",@"icons_filled_add_friends.svg",@"icons_filled_scan.svg",@"icons_outlined_pay.svg"];
    
    NSArray *titles = @[@"发起群聊",@"添加朋友",@"扫一扫",@"收付款"];
    
    for (NSInteger i = 0; i<titles.count; i++) {
        
        MHMainFrameMoreItemView *itemView = [[MHMainFrameMoreItemView alloc] init];
        itemView.tag = i;
        UIImage *image = [UIImage mh_svgImageNamed:images[i] targetSize:CGSizeMake(24.0f, 24.0f) tintColor:[UIColor whiteColor]];
        [itemView setImage:image forState:UIControlStateNormal];
        [itemView setImage:image forState:UIControlStateHighlighted];
        [itemView setTitle:titles[i] forState:UIControlStateNormal];
        [itemView setTitle:titles[i] forState:UIControlStateHighlighted];
        [menuView addSubview:itemView];
        @weakify(self);
        [[itemView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIView *x) {
            @strongify(self);
            !self.menuItemAction?:self.menuItemAction(x.tag);
        }];
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
        make.height.mas_equalTo(6 + 57 * 4);
    }];
    
    
    /// 布局三角形
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).with.offset(-15.0);
        make.top.equalTo(self.containerView).with.offset(.0);
        make.width.mas_equalTo(13.0f);
        make.height.mas_equalTo(6.0f);
    }];
    
    /// 布局menuView
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.containerView);
        make.top.equalTo(self.triangleView.mas_bottom);
    }];
    
    /// 布局item
    UIView *lastView = nil;
    CGFloat height = 57.0f;
    NSInteger count = self.menuView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *view = self.menuView.subviews[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView ? lastView.mas_bottom : @0);
            make.left.and.right.equalTo(self.menuView);
            make.height.mas_equalTo(height);
        }];
        lastView = view;
    }
}
@end
