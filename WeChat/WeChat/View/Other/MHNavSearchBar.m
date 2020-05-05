//
//  MHNavSearchBar.m
//  WeChat
//
//  Created by 何千元 on 2020/5/3.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHNavSearchBar.h"
#import "MHNavSearchBarViewModel.h"

@interface MHNavSearchBar ()
/// viewModel
@property (nonatomic, readwrite, strong) MHNavSearchBarViewModel *viewModel;
/// 背景view
@property (nonatomic, readwrite, weak) UIView *backgroundView;

/// textField
@property (nonatomic, readwrite, weak) MHTextField *textField;

/// leftView
@property (nonatomic, readwrite, strong) UIView *leftView;

/// 取消按钮
@property (nonatomic, readwrite, weak) UIButton *cancelBtn;

/// cancelBtnWidth
@property (nonatomic, readwrite, assign) CGFloat cancelBtnWidth;

/// 最小宽度
@property (nonatomic, readwrite, assign) CGFloat textFieldMinWidth;

@end

@implementation MHNavSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - Overwrite
- (void)bindViewModel:(MHNavSearchBarViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [[[RACObserve(self, viewModel.animating) skip:1] distinctUntilChanged]  subscribeNext:^(NSNumber *animating) {
        @strongify(self);
        
        NSLog(@"animating is %d", animating.boolValue);
        
        self.userInteractionEnabled = false;
        
        // backgroundView
//        CGFloat offset = animating.boolValue ? -1 * self.cancelBtnWidth : -8.0;
//        [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).with.offset(offset);
//        }];
        
        // 取消按钮
        CGFloat offset1 = animating.boolValue ? 0 : self.cancelBtnWidth - 8.0f;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(offset1);
        }];
        
        // textFeild
        CGFloat offset2 = animating.boolValue ? 8.0 : (MH_SCREEN_WIDTH - self.textFieldMinWidth) * 0.5;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset2);
        }];
        
        
        // 更新布局
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = true;
        }];
        
    }];
}

#pragma mark - 辅助方法
- (void)_cancelBtnDidClicked:(UIButton *)sender{
       
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

/// 创建子控件
- (void)_setupSubviews{
    
    @weakify(self);
    
    // 背景View
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    backgroundView.layer.cornerRadius = 6.0f;
    backgroundView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
    [backgroundView addGestureRecognizer:tapGr];
    [tapGr.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.animateCommand execute:@1];
    }];
    
    // textField
    MHTextField *textField = [[MHTextField alloc] init];
    textField.placeholder = @"搜索";
    textField.font = MHRegularFont_16;
    textField.leftView = self.leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 编辑模式
    textField.enabled = NO;
    
    [self addSubview:textField];
    self.textField = textField;
    
    /// 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:MHColorFromHexString(@"#576b94") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[MHColorFromHexString(@"#576b94") colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = MHRegularFont_16;
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.animateCommand execute:@0];
    }];
    
    
}




/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    
    
    
    // 计算按钮宽度
    CGFloat cancelBtnWidth = [@"取消" mh_sizeWithFont:MHRegularFont_16].width;
    self.cancelBtnWidth = cancelBtnWidth + 22.0f;
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(self.cancelBtnWidth - 8.0f);
        make.width.mas_equalTo(self.cancelBtnWidth);
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(8.0);
        make.right.equalTo(self.cancelBtn.mas_left);
        make.height.mas_equalTo(36.0f);
    }];
    
    /// 布局TextField
    self.textFieldMinWidth = 36.0f + cancelBtnWidth;
    CGFloat offset = (MH_SCREEN_WIDTH - self.textFieldMinWidth) * 0.5;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cancelBtn.mas_left);
        make.left.equalTo(self).with.offset(offset);
        make.height.mas_equalTo(36.0);
        make.centerY.equalTo(self);
    }];
}

- (UIView *)leftView{
    if (_leftView == nil) {
        
        UIColor *color = [UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.3];
        UIImage *image = [UIImage mh_svgImageNamed:@"icons_outlined_search.svg" targetSize:CGSizeMake(20.0, 20.0) tintColor:color];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.contentMode = UIViewContentModeCenter;
        imageView.mh_size = CGSizeMake(36, 36);
    
        // ios 13.0： imageView 设置宽高无效
        UIView *leftView = [[UIView alloc] init];
        leftView.mh_size = imageView.mh_size;
        [leftView addSubview:imageView];
        
        _leftView = leftView;
    }

    return _leftView;
}


/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSLog(@"size is %@", NSStringFromCGRect(self.bounds));
}




@end
