//
//  MHVideoTrendsBubbleItemView.h
//  WeChat
//
//  Created by 何千元 on 2020/8/5.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHVideoTrendsBubbleItemView : UIView
+ (instancetype)bubbleItemView;

/// inset
@property (nonatomic, readwrite, assign) CGFloat inset;
@end

NS_ASSUME_NONNULL_END
