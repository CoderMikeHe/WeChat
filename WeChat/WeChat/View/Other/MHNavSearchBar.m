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

/// 取消按钮
@property (nonatomic, readwrite, weak) UIButton *cancelBtn;

/// 返回按钮
@property (nonatomic, readwrite, weak) UIButton *backBtn;
/// backBtnWidth
@property (nonatomic, readwrite, assign) CGFloat backBtnWidth;

/// cancelBtnWidth
@property (nonatomic, readwrite, assign) CGFloat cancelBtnWidth;

/// 最小宽度
@property (nonatomic, readwrite, assign) CGFloat textFieldMinWidth;


/// isEdit
@property (nonatomic, readwrite, assign, getter=isEdit) BOOL edit;

/// searchType
@property (nonatomic, readwrite, assign) MHSearchType searchType;

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
    [[self.viewModel.editSubject deliverOnMainThread] subscribeNext:^(NSNumber *isEdit) {
        @strongify(self);
        
        self.edit = isEdit.boolValue;
        
        self.userInteractionEnabled = false;
        
        // 取消按钮
        CGFloat offset1 = isEdit.boolValue ? 0 : self.cancelBtnWidth - 8.0f;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(offset1);
        }];
        
        // textFeild
        CGFloat offset2 = isEdit.boolValue ? 8.0 : (MH_SCREEN_WIDTH - self.textFieldMinWidth) * 0.5;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset2);
        }];
        
        // 退出编辑 且 搜索类型 不是默认状态  要把 < 按钮归位
        if (!self.isEdit && self.searchType != MHSearchTypeDefault) {
            CGFloat offsetX0 = -self.backBtnWidth + 8.0f;
            [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(offsetX0);
            }];
            // 重新设置为默认
            [self.viewModel.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
        }
        
        // 更新布局
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = true;

            self.textField.enabled = isEdit.boolValue;
        }];

    }];
    
    /// 监听searchType
    [[self.viewModel.searchTypeSubject deliverOnMainThread] subscribeNext:^(NSNumber *type) {
        
        @strongify(self);

        MHSearchType searchType = type.integerValue;
        self.searchType = searchType;
        
        self.textField.placeholder = [self _fetchPlaceholder:searchType];
        self.textField.leftView = [self _fetchLeftView:searchType];
        
        
        // 非编辑模式 do nothing...
        if (!self.isEdit) {
            return ;
        }
        
        /// 更新布局
        self.userInteractionEnabled = NO;
        
        CGFloat offsetX0 = searchType != MHSearchTypeDefault ? 0 : -self.backBtnWidth + 8.0f;
        
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(offsetX0);
        }];
        
        CGFloat offsetX1 = searchType != MHSearchTypeDefault ? self.backBtnWidth : 8.0f;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(offsetX1);
        }];
        
        // 更新布局
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

#pragma mark - 辅助方法
- (void)_cancelBtnDidClicked:(UIButton *)sender{
       
}

/// 获取placeholder
- (NSString *)_fetchPlaceholder:(MHSearchType)type {
    NSString *placeholder = @"小程序";
    switch (type) {
        case MHSearchTypeMoments:
            placeholder = @"搜索朋友圈";
            break;
        case MHSearchTypeSubscriptions:
            placeholder = @"搜索文章";
            break;
        case MHSearchTypeOfficialAccounts:
            placeholder = @"搜索公众号";
            break;
        case MHSearchTypeMiniprogram:
            placeholder = @"搜索小程序";
            break;
        case MHSearchTypeMusic:
            placeholder = @"搜索音乐";
            break;
        case MHSearchTypeSticker:
            placeholder = @"搜索表情";
            break;
        default:
            placeholder = @"搜索";
            break;
    }
    
    return placeholder;
}

/// 获取leftView
- (UIView *)_fetchLeftView:(MHSearchType)type {
    
    NSString *imageName = @"小程序";
    switch (type) {
        case MHSearchTypeMoments:
            imageName = @"icons_outlined_searchicon_moment.svg";
            break;
        case MHSearchTypeSubscriptions:
            imageName = @"icons_outlined_searchicon_subscriptions.svg";
            break;
        case MHSearchTypeOfficialAccounts:
            imageName = @"icons_outlined_searchicon_official_accounts.svg";
            break;
        case MHSearchTypeMiniprogram:
            imageName = @"icons_outlined_searchicon_miniprogram.svg";
            break;
        case MHSearchTypeMusic:
            imageName = @"icons_outlined_searchicon_music.svg";
            break;
        case MHSearchTypeSticker:
            imageName = @"icons_outlined_searchicon_sticker.svg";
            break;
        default:
            imageName = @"icons_outlined_search_full.svg";
            break;
    }
    
    UIColor *color = [UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.3];
    UIImage *image = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(16.0, 16.0) tintColor:color];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.mh_size = CGSizeMake(36, 36);
    
    // ios 13.0： imageView 设置宽高无效
    UIView *leftView = [[UIView alloc] init];
    leftView.mh_size = imageView.mh_size;
    [leftView addSubview:imageView];
    
    return leftView;
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

/// 创建子控件
- (void)_setupSubviews{
    
    @weakify(self);
    
    // backBtn
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:MHColorFromHexString(@"#b6b6b6")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_filled_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:[MHColorFromHexString(@"#b6b6b6") colorWithAlphaComponent:0.5]];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:imageHigh forState:UIControlStateHighlighted];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
    }];
    
    
    
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
        [self.viewModel.editSubject sendNext:@1];
    }];
    
    // textField
    MHTextField *textField = [[MHTextField alloc] init];
    textField.placeholder = [self _fetchPlaceholder:MHSearchTypeDefault];
    textField.leftView = [self _fetchLeftView:MHSearchTypeDefault];
    textField.font = MHRegularFont_16;
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
        [self.viewModel.editSubject sendNext:@0];
    }];
}




/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    /// 计算返回按钮的宽度
    self.backBtnWidth = 16 + 12 + 16;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(-self.backBtnWidth + 8.0f);
        make.width.mas_equalTo(self.backBtnWidth);
    }];
    
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
        make.left.equalTo(self.backBtn.mas_right).with.offset(0.0);
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



/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
}




@end
