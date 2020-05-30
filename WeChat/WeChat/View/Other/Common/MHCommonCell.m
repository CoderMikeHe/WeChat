//
//  MHCommonCell.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonCell.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHCommonAvatarItemViewModel.h"
#import "MHCommonQRCodeItemViewModel.h"
#import "MHCommonLabelItemViewModel.h"
#import "MHCommonSwitchItemViewModel.h"
@interface MHCommonCell ()
/// viewModel
@property (nonatomic, readwrite, strong) MHCommonItemViewModel *viewModel;

/// 箭头
@property (nonatomic, readwrite, strong) UIImageView *rightArrow;
/// 开光
@property (nonatomic, readwrite, strong) UISwitch *rightSwitch;
/// 标签
@property (nonatomic, readwrite, strong) UILabel *rightLabel;
/// avatar 头像
@property (nonatomic, readwrite, weak) UIImageView *avatarView;
/// QrCode
@property (nonatomic, readwrite, weak) UIImageView *qrCodeView;

/// 三条分割线
@property (nonatomic, readwrite, weak) UIImageView *divider0;
@property (nonatomic, readwrite, weak) UIImageView *divider1;
@property (nonatomic, readwrite, weak) UIImageView *divider2;

/// 中间偏左 view
@property (nonatomic, readwrite, weak) UIImageView *centerLeftView;
/// 中间偏右 view
@property (nonatomic, readwrite, weak) UIImageView *centerRightView;
@end


@implementation MHCommonCell

#pragma mark - 公共方法
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    return [self cellWithTableView:tableView style:UITableViewCellStyleValue1];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style{
    static NSString *ID = @"CommonCell";
    MHCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows{
    self.divider0.hidden = NO;
    self.divider1.hidden = NO;
    self.divider2.hidden = NO;
    if (rows == 1) {                      /// 一段
        self.divider1.hidden = YES;
    }else if(indexPath.row == 0) {        /// 首行
        self.divider2.hidden = YES;
    }else if(indexPath.row == rows-1) {   /// 末行
        self.divider1.hidden = YES;
        self.divider0.hidden = YES;
    }else{ /// 中间行
        self.divider1.hidden = NO;
        self.divider0.hidden = YES;
        self.divider2.hidden = YES;
    }
}


- (void)bindViewModel:(MHCommonItemViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.avatarView.hidden = YES;
    self.qrCodeView.hidden = YES;
    
    self.selectionStyle = viewModel.selectionStyle;
    self.textLabel.text = viewModel.title;
 
    
    /// 增加svg 逻辑
    if (MHStringIsNotEmpty(viewModel.icon)) {
        if (viewModel.isSvg) {
            if (viewModel.svgTintColor) {
                self.imageView.image = [UIImage mh_svgImageNamed:viewModel.icon targetSize:viewModel.svgSize tintColor:viewModel.svgTintColor];
            }else {
                self.imageView.image = [UIImage mh_svgImageNamed:viewModel.icon targetSize:viewModel.svgSize];
            }
        } else {
            self.imageView.image = MHImageNamed(viewModel.icon);
        }
    } else {
        self.imageView.image = nil;
    }
    
    
    self.detailTextLabel.text = viewModel.subtitle;
    /// 设置全新
    if (MHStringIsNotEmpty(viewModel.centerLeftViewName)) {
        self.centerLeftView.hidden = NO;
        self.centerLeftView.image = MHImageNamed(viewModel.centerLeftViewName);
        self.centerLeftView.mh_size = self.centerLeftView.image.size;
    }else{
        self.centerLeftView.hidden = YES;;
    }
    
    /// 设置锁
    if (MHStringIsNotEmpty(viewModel.centerRightViewName)) {
        self.centerRightView.hidden = NO;
        self.centerRightView.image = MHImageNamed(viewModel.centerRightViewName);
        self.centerRightView.mh_size = self.centerRightView.image.size;
    }else{
        self.centerRightView.hidden = YES;;
    }

    if ([viewModel isKindOfClass:[MHCommonArrowItemViewModel class]]) {  /// 纯带箭头
        self.accessoryView = self.rightArrow;
        if ([viewModel isKindOfClass:[MHCommonAvatarItemViewModel class]]) { // 头像
            MHCommonAvatarItemViewModel *avatarViewModel = (MHCommonAvatarItemViewModel *)viewModel;
            self.avatarView.hidden = NO;
            [self.avatarView yy_setImageWithURL:[NSURL URLWithString:avatarViewModel.avatar] placeholder:MHWebAvatarImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
        }else if ([viewModel isKindOfClass:[MHCommonQRCodeItemViewModel class]]){ // 二维码
            self.qrCodeView.hidden = NO;
        }
    }else if([viewModel isKindOfClass:[MHCommonSwitchItemViewModel class]]){ /// 开关
        // 右边显示开关
        MHCommonSwitchItemViewModel *switchViewModel = (MHCommonSwitchItemViewModel *)viewModel;
        self.accessoryView = self.rightSwitch;
        self.rightSwitch.on = !switchViewModel.off;
    }else{
        self.accessoryView = nil;
    }
}
#pragma mark - 私有方法
- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化
- (void)_setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = MHColorFromHexString(@"#888888");
    self.detailTextLabel.numberOfLines = 0;
    self.textLabel.font = MHRegularFont_17;
    self.detailTextLabel.font = MHRegularFont_16;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    /// CoderMikeHe Fixed : 这里需要把divider添加到self，而不是self.contentView ,由于添加了 accessView，导致self.contentView的宽度<self的宽度
    // 分割线
    UIImageView *divider0 = [[UIImageView alloc] init];
    self.divider0 = divider0;
    [self addSubview:divider0];
    UIImageView *divider1 = [[UIImageView alloc] init];
    self.divider1 = divider1;
    [self addSubview:divider1];
    UIImageView *divider2 = [[UIImageView alloc] init];
    self.divider2 = divider2;
    [self addSubview:divider2];
    divider0.backgroundColor = divider1.backgroundColor = divider2.backgroundColor = MH_MAIN_LINE_COLOR_1;
    
    /// 添加用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    self.avatarView = avatarView;
    avatarView.hidden = YES;
    [self.contentView addSubview:avatarView];
    /// 设置圆角+线宽
    [avatarView zy_attachBorderWidth:1.0f color:MHColorFromHexString(@"#BFBFBF")];
    [avatarView zy_cornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    
    /// 二维码照片
    UIImageView *qrCodeView = [[UIImageView alloc] initWithImage:MHImageNamed(@"setting_myQR_18x18")];
    qrCodeView.hidden = YES;
    self.qrCodeView = qrCodeView;
    [self.contentView addSubview:qrCodeView];
    
    /// 中间偏左的图片
    UIImageView *centerLeftView = [[UIImageView alloc] init];
    centerLeftView.hidden = YES;
    self.centerLeftView = centerLeftView;
    [self.contentView addSubview:centerLeftView];
    
    /// 中间偏左的图片
    UIImageView *centerRightView = [[UIImageView alloc] init];
    centerRightView.hidden = YES;
    self.centerRightView = centerRightView;
    [self.contentView addSubview:centerRightView];
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    /// 设置
    if ((fabs(self.textLabel.mh_x - self.detailTextLabel.mh_x) <=.1f)) {
        /// SubTitle
        self.textLabel.mh_bottom = self.detailTextLabel.mh_top;
    }else{
        self.textLabel.mh_centerY = self.mh_height * .5f;
    }
    
    
    self.divider0.frame = CGRectMake(0, 0, self.mh_width, MHGlobalBottomLineHeight);
    self.divider1.frame = CGRectMake(self.textLabel.mh_x, self.mh_height-MHGlobalBottomLineHeight, self.mh_width-14, MHGlobalBottomLineHeight);
    self.divider2.frame = CGRectMake(0, self.mh_height-MHGlobalBottomLineHeight, self.mh_width, MHGlobalBottomLineHeight);
    
    /// 设置头像
    self.avatarView.mh_size = CGSizeMake(66, 66);
    self.avatarView.mh_right = self.accessoryView.mh_left - 7;
    self.avatarView.mh_centerY = self.mh_height * .5f;
    
    /// 设置二维码
    self.qrCodeView.mh_right = self.accessoryView.mh_left - 11;
    self.qrCodeView.mh_centerY = self.mh_height * .5f;
    
    /// 配置Artboard
    self.centerLeftView.mh_left = self.textLabel.mh_right + 14;
    self.centerLeftView.mh_centerY = self.mh_height * .5f;
    
    /// 配置
    self.centerRightView.mh_right = self.detailTextLabel.mh_left - 5;
    self.centerRightView.mh_centerY = self.mh_height * .5f;
}

#pragma mark - 事件处理
- (void)_switchValueDidiChanged:(UISwitch *)sender{
    MHCommonSwitchItemViewModel *switchViewModel = (MHCommonSwitchItemViewModel *)self.viewModel;
    switchViewModel.off = !sender.isOn;
}



#pragma mark - Setter Or Getter
- (UIImageView *)rightArrow{
    if (_rightArrow == nil) {
        // arrow
        UIImage *image = [UIImage mh_svgImageNamed:@"icons_outlined_arrow.svg"];
        _rightArrow = [[UIImageView alloc] initWithImage:image];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch{
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(_switchValueDidiChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

@end
