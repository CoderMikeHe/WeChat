//
//  UIImage+MHSVG.h
//  WeChat
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MHSVG)
/**
 show svg image
 
 @param name svg name
 @return svg image
 */
+ (UIImage *)mh_svgImageNamed:(NSString *)name;



/**
 show svg image
 
 @param name svg name
 @param targetSize image size
 @return svg image
 */
+ (UIImage *)mh_svgImageNamed:(NSString *)name targetSize:(CGSize)size;


/**
 show svg image
 
 @param name       svg name
 @param targetSize image size
 @param tintColor  image color
 @return svg image
 */
+ (UIImage *)mh_svgImageNamed:(NSString *)name targetSize:(CGSize)size tintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
