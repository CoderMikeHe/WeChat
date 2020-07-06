//
//  UIScrollView+MHExtension.h
//  WeChat
//
//  Created by admin on 2020/7/2.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MHExtension)
@property (assign, nonatomic) CGFloat mh_insetT;
@property (assign, nonatomic) CGFloat mh_insetB;
@property (assign, nonatomic) CGFloat mh_insetL;
@property (assign, nonatomic) CGFloat mh_insetR;

@property (assign, nonatomic) CGFloat mh_offsetX;
@property (assign, nonatomic) CGFloat mh_offsetY;

@property (assign, nonatomic) CGFloat mh_contentW;
@property (assign, nonatomic) CGFloat mh_contentH;
@end

NS_ASSUME_NONNULL_END
