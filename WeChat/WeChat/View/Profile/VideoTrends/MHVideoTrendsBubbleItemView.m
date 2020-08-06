//
//  MHVideoTrendsBubbleItemView.m
//  WeChat
//
//  Created by 何千元 on 2020/8/5.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHVideoTrendsBubbleItemView.h"

@interface MHVideoTrendsBubbleItemView ()

/// imageView
@property (nonatomic, readwrite, weak) UIImageView *imageView;

@end

@implementation MHVideoTrendsBubbleItemView

+ (instancetype)bubbleItemView {
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

- (void)setInset:(CGFloat)inset {
    _inset = inset;
    
    [self setNeedsLayout];
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
    self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    _inset = .0f;
}

/// 创建子控件
- (void)_setupSubviews{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self addSubview:imageView];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.mh_width > 0 && self.mh_height > 0) {
        UIImage *image = [UIImage mh_svgImageNamed:@"icons_story_chatroom_entry.svg" targetSize:CGSizeMake(self.mh_width, self.mh_width) tintColor:MHColorFromHexString(@"#E0E0E0")];
        self.layer.cornerRadius = self.mh_width * .5f;
        self.masksToBounds = YES;
        self.imageView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.inset, self.inset, self.inset, self.inset));
        self.imageView.image = image;
    }
}


@end
