//
//  MHMomentPhotosView.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentPhotosView.h"
#import "MHMomentPhotoView.h"
#import "MHMomentItemViewModel.h"
#import "YYPhotoGroupView.h"

@interface MHMomentPhotosView ()
/// viewModel
@property (nonatomic, readwrite, strong) MHMomentItemViewModel *viewModel;
@end

@implementation MHMomentPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 预先创建9个图片控件 避免动态创建
        for (int i = 0; i<MHMomentPhotosMaxCount; i++) {
            MHMomentPhotoView *photoView = [[MHMomentPhotoView alloc] init];
            photoView.backgroundColor = self.backgroundColor;
            photoView.hidden = YES;
            photoView.tag = i;
            [self addSubview:photoView];
            
            // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(_tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
        }
    }
    return self;
}


/// bind data
- (void)bindViewModel:(MHMomentItemViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    CGFloat photoViewWH = MHMomentPhotosViewItemWidth();
    
    /// 设置显示or隐藏以及布局
    NSUInteger count = viewModel.picInfos.count;
    
    if (count==0) [self _hideAllImageViews];
    
    int maxCols = MHMomentMaxCols(count);
    for (int i = 0; i<MHMomentPhotosMaxCount; i++) {
        MHMomentPhotoView *photoView = self.subviews[i];
        
        if (i < count)
        {
            /// 显示隐藏
            photoView.hidden = NO;
            
            if(count == 1)
            {   /// 一张图的情况
                photoView.frame = self.bounds;
            }else{
                /// 其他情况
                photoView.mh_width = photoViewWH;
                photoView.mh_height = photoViewWH;
                photoView.mh_x = (i % maxCols) * (photoViewWH + MHMomentPhotosViewItemInnerMargin);
                photoView.mh_y = (i / maxCols) * (photoViewWH + MHMomentPhotosViewItemInnerMargin);
            }
            // 绑定数据
            [photoView bindViewModel:viewModel.picInfos[i]];
            
        } else {
            // 隐藏
            /// 这里我重写了子控件的 hidden方法 目的是取消 图片下载请求
            photoView.hidden = YES;
        }
    }
    
}

/// 隐藏所有图片
- (void)_hideAllImageViews {
    for (MHMomentPhotoView *imageView in self.subviews) {
        imageView.hidden = YES;
    }
}

#pragma mark - 事件处理
- (void)_tapPhoto:(UITapGestureRecognizer *)sender
{
    /// 图片浏览
    NSMutableArray *items = [NSMutableArray new];
    
    CGFloat count = self.viewModel.picInfos.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIView *imgView = self.subviews[i];
        MHPicture *picture = [self.viewModel.picInfos[i] picture];
        MHPictureMetadata *meta = picture.largest.badgeType == MHPictureBadgeTypeGIF ? picture.largest : picture.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;
        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
    }
    
    YYPhotoGroupView *photoBrowser = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [photoBrowser presentFromImageView:sender.view toContainer:self.window animated:YES completion:nil];
    
}


@end
