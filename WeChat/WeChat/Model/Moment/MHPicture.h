//
//  MHPicture.h
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHObject.h"
#import "MHPictureMetadata.h"
@interface MHPicture : MHObject
/// 图片模型id
@property (nonatomic, readwrite, copy) NSString *picID;
@property (nonatomic, readwrite, copy) NSString *objectID;
@property (nonatomic, readwrite, assign) int photoTag;
/// < YES:固定为方形 NO:原始宽高比
@property (nonatomic, readwrite, assign) BOOL keepSize;
/// < w:180
@property (nonatomic, readwrite, strong) MHPictureMetadata *thumbnail;
/// < w:360 (列表中的缩略图)
@property (nonatomic, readwrite, strong) MHPictureMetadata *bmiddle;
/// < w:480
@property (nonatomic, readwrite, strong) MHPictureMetadata *middlePlus;
/// < w:720 (放大查看)
@property (nonatomic, readwrite, strong) MHPictureMetadata *large;
/// < (查看原图)
@property (nonatomic, readwrite, strong) MHPictureMetadata *largest;
/// < 原图
@property (nonatomic, readwrite, strong) MHPictureMetadata *original;
/// 图片标记类型
@property (nonatomic, readwrite, assign) MHPictureBadgeType badgeType;
@end
