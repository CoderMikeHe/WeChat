//
//  UIScrollView+MHExtension.m
//  WeChat
//
//  Created by admin on 2020/7/2.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "UIScrollView+MHExtension.h"

@implementation UIScrollView (MHExtension)
- (void)setMh_insetT:(CGFloat)mh_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = mh_insetT;
    self.contentInset = inset;
}

- (CGFloat)mh_insetT
{
    return self.contentInset.top;
}

- (void)setMh_insetB:(CGFloat)mh_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mh_insetB;
    self.contentInset = inset;
}

- (CGFloat)mh_insetB
{
    return self.contentInset.bottom;
}

- (void)setMh_insetL:(CGFloat)mh_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = mh_insetL;
    self.contentInset = inset;
}

- (CGFloat)mh_insetL
{
    return self.contentInset.left;
}

- (void)setMh_insetR:(CGFloat)mh_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = mh_insetR;
    self.contentInset = inset;
}

- (CGFloat)mh_insetR
{
    return self.contentInset.right;
}

- (void)setMh_offsetX:(CGFloat)mh_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = mh_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)mh_offsetX
{
    return self.contentOffset.x;
}

- (void)setMh_offsetY:(CGFloat)mh_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = mh_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)mh_offsetY
{
    return self.contentOffset.y;
}

- (void)setMh_contentW:(CGFloat)mh_contentW
{
    CGSize size = self.contentSize;
    size.width = mh_contentW;
    self.contentSize = size;
}

- (CGFloat)mh_contentW
{
    return self.contentSize.width;
}

- (void)setMh_contentH:(CGFloat)mh_contentH
{
    CGSize size = self.contentSize;
    size.height = mh_contentH;
    self.contentSize = size;
}

- (CGFloat)mh_contentH
{
    return self.contentSize.height;
}
@end
