//
//  UIImage+MHSVG.m
//  WeChat
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

// 针对SVGKit 做拓展
// 参照👉: https://www.jianshu.com/p/6b82beae0379

#import "UIImage+MHSVG.h"
#import "SVGKImage.h"

@implementation UIImage (MHSVG)
/**
 show svg image
 
 @param name svg name
 @param targetSize image size
 @return svg image
 */
+ (UIImage *)mh_svgImageNamed:(NSString *)name targetSize:(CGSize)size{
    SVGKImage *svgImage = [SVGKImage imageNamed:name];
    svgImage.size = size;
    return svgImage.UIImage;
}


/**
 show svg image
 
 @param name       svg name
 @param targetSize image size
 @param tintColor  image color
 @return svg image
 */
+ (UIImage *)mh_svgImageNamed:(NSString *)name targetSize:(CGSize)size tintColor:(UIColor *)tintColor{
    SVGKImage *svgImage = [SVGKImage imageNamed:name];
    svgImage.size = size;
    CGRect rect = CGRectMake(0, 0, svgImage.size.width, svgImage.size.height);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(svgImage.UIImage.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    UIGraphicsBeginImageContextWithOptions(svgImage.size, opaque, svgImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, svgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextClipToMask(context, rect, svgImage.UIImage.CGImage);
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillRect(context, rect);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
@end
