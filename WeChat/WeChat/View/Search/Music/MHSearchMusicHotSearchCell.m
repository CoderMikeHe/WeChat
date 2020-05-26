//
//  MHSearchMusicHotSearchCell.m
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicHotSearchCell.h"
#import "MHSearchMusicHotItemViewModel.h"
@interface MHSearchMusicHotSearchCell ()

/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;
/// viewModel
@property (nonatomic, readwrite, strong) MHSearchMusicHotItemViewModel *viewModel;
@end

@implementation MHSearchMusicHotSearchCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SearchMusicHotSearchCell";
    MHSearchMusicHotSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)bindViewModel:(MHSearchMusicHotItemViewModel *)viewModel {
    self.viewModel = viewModel;
    /// 设置显示or隐藏以及布局
    NSUInteger count = viewModel.musics.count;
    NSUInteger length = self.containerView.subviews.count;
    for (int i = 0; i < length; i++) {
        UILabel *label = self.containerView.subviews[i];
        if (i < count) {
            /// 显示
            label.hidden = NO;
            label.text = viewModel.musics[i];
        } else {
            // 隐藏
            label.hidden = YES;
        }
    }
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = self.contentView.backgroundColor = [UIColor whiteColor];
}

/// 创建子控件
- (void)_setupSubviews{
    
    // 容器
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    
    /// 最多八条数据
    NSInteger count = 8;
    for (NSInteger i = 0 ; i < count; i++) {
        /// label
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = MHRegularFont_14;
        label.textColor = MHColorFromHexString(@"#5B6A91");
        label.numberOfLines = 1;
        label.text = @"";
        [containerView addSubview:label];
        // 默认隐藏
        label.hidden = YES;
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
        [label addGestureRecognizer:tapGr];
        @weakify(self);
        [tapGr.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            MHSearch *search = [MHSearch searchWithKeyword:self.viewModel.musics[i] searchMode:MHSearchModeSearch];
            [self.viewModel.requestSearchKeywordCommand execute:search];
        }];
    }
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // z布局containerView
    CGFloat containerViewX = 20.0f;
    CGFloat containerViewY = 10.0f;
    CGFloat containerViewW = self.contentView.mh_width - 2 * containerViewX;
    CGFloat containerViewH = self.contentView.mh_height - 2 * containerViewY;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    
    /// 布局子控件
    CGFloat w = containerViewW * 0.5f;
    CGFloat h = [@"隔壁老樊" mh_sizeWithFont:MHRegularFont_14 limitWidth:CGFLOAT_MAX].height + 20;
    NSUInteger count = self.containerView.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        UIView *v = self.containerView.subviews[i];
        CGFloat vW = w;
        CGFloat vH = h;
        CGFloat vX = 0;
        CGFloat vY = 0;
        vX = (i % 2) * vW;
        vY = (i / 2) * vH;
        v.frame = CGRectMake(vX, vY, vW, vH);
    }
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
