//
//  MHPulldownAppletCell.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletCell.h"
#import "MHPulldownAppletItemView.h"

@interface MHPulldownAppletCell ()

/// viewModel
@property (nonatomic, readwrite, copy) NSArray * viewModel;

/// 父容器
@property (nonatomic, readwrite, weak) UIView *container;

@end


@implementation MHPulldownAppletCell


#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"PulldownAppletCell";
    MHPulldownAppletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)bindViewModel:(NSArray *)viewModel{
    self.viewModel = viewModel;
    
    NSUInteger count = self.container.subviews.count;
    NSUInteger cnt = viewModel.count;
    
    for (NSInteger i = 0; i < count; i++) {
        MHPulldownAppletItemView *itemView = self.container.subviews[i];
        if (i < cnt) {
            itemView.hidden = NO;
            id vm = viewModel[i];
            [itemView bindViewModel:vm];
        }else{
            itemView.hidden = YES;
        }
    }

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}




#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
   self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
}

/// 创建子控件
- (void)_setupSubviews{
    @weakify(self);
    
    /// 父容器
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [self.contentView addSubview:container];
    
    /// 子控件
    NSUInteger count = 4;
    for (NSInteger i = 0; i < count; i++) {
        MHPulldownAppletItemView *appletView = [MHPulldownAppletItemView appletItemView];
        [container addSubview:appletView];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
        [appletView addGestureRecognizer:tapGr];
        
        [tapGr.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"Applet did clicked ...");
        }];
    }
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 布局父容器
    CGFloat margin = 36.5f;
    CGFloat containerW = self.mh_width - margin * 2.0f;
    
    CGFloat containerX = margin;
    CGFloat containerY = 0;
    CGFloat containerH = self.mh_height;
    self.container.frame = CGRectMake(containerX, containerY, containerW, containerH);
    
    /// 布局子控件
    NSUInteger count = self.container.subviews.count;
    CGFloat viewW = 60.0f;
    CGFloat viewH = self.mh_height - 23.0f;
    CGFloat innerSpace = (containerW - count * viewW) / (count-1);
    for (NSInteger i = 0; i < count; i++) {
        UIView *view = self.container.subviews[i];
        CGFloat viewX = i * (viewW + innerSpace);
        view.frame = CGRectMake(viewX, 0, viewW, viewH);
    }
}

@end
