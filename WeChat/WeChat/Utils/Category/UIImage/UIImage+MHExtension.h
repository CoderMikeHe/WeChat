//
//  UIImage+MHExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/8/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MHExtension)
/**
 *  根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
 */
+ (UIImage *)mh_resizableImage:(NSString *)imgName;
+ (UIImage *)mh_resizableImage:(NSString *)imgName capInsets:(UIEdgeInsets)capInsets;


/// 返回一张未被渲染的图片
+ (UIImage *)mh_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName;
@end
