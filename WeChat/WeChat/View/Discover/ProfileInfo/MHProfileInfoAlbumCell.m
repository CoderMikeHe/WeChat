//
//  MHProfileInfoAlbumCell.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHProfileInfoAlbumCell.h"
#import "MHProfileInfoViewModel.h"
@interface MHProfileInfoAlbumCell ()
/// albumView
@property (nonatomic, readwrite, weak) UIView *albumView;
/// 箭头
@property (nonatomic, readwrite, strong) UIImageView *rightArrow;
/// viewModel
@property (nonatomic, readwrite, strong) MHProfileInfoViewModel *viewModel;
@end


@implementation MHProfileInfoAlbumCell
- (void)bindViewModel:(MHProfileInfoViewModel *)viewModel{
    self.viewModel = viewModel;
    
    NSInteger count = self.albumView.subviews.count;
    NSInteger picsCount = viewModel.pictures.count;
    for (NSInteger i = 0 ; i < count; i++) {
        UIImageView *picture = self.albumView.subviews[i];
        if (i < picsCount) {
            picture.hidden = NO;
            [picture yy_setImageWithURL:[NSURL URLWithString:viewModel.pictures[i]] placeholder:MHWebImagePlaceholder() options:MHWebImageOptionAutomatic completion:NULL];
        }else{
            picture.hidden = YES;
        }
    }
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ProfileInfoAlbumCell";
    MHProfileInfoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /// 创建一个相册View
    UIView *albumView = [[UIView alloc] init];
    self.albumView = albumView;
    [self.contentView addSubview:albumView];
    
    /// 最多显示四个图片
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *picture = [[UIImageView alloc] init];
        [albumView addSubview:picture];
    }
    
    /// 箭头
    self.accessoryView = self.rightArrow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Setter Or Getter
- (UIImageView *)rightArrow{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:MHImageNamed(@"tableview_arrow_8x13")];
    }
    return _rightArrow;
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat albumViewX = 94;
    CGFloat albumViewY = 0;
    CGFloat albumViewW = self.accessoryView.mh_left - 20 - albumViewX;
    CGFloat albumViewH = self.mh_height - 2 * 16;
    
    self.albumView.frame = CGRectMake(albumViewX, albumViewY, albumViewW, albumViewH);
    self.albumView.mh_centerY = self.mh_height * .5f;
    
    CGFloat innerMargin = 10;
    NSInteger count = self.albumView.subviews.count;
    CGFloat WH = (albumViewW - (count - 1) * innerMargin )/count;
    /// 布局内部图片
    for (NSInteger i = 0; i < count; i++) {
        UIImageView *picture = self.albumView.subviews[i];
        picture.frame = CGRectMake((WH + innerMargin) * i, 0, WH, WH);
    }
}
@end
