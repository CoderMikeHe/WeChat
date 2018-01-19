//
//  MHMomentPhotoItemViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  配图中单张图片的视图模型

#import "MHMomentPhotoItemViewModel.h"


@implementation MHMomentPhotoItemViewModel

- (instancetype)initWithPicture:(MHPicture *)picture
{
    if(self = [super init])
    {
        self.picture = picture;
    }
    
    return self;
}

@end
