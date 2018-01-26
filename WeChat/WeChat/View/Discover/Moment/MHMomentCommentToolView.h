//
//  MHMomentCommentToolView.h
//  WeChat
//
//  Created by senba on 2018/1/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  评论输入框

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"
@interface MHMomentCommentToolView : UIView<MHReactiveView>

/// toHeight (随着文字的输入，MHMomentCommentToolView 将要到达的高度)
@property (nonatomic, readonly, assign) CGFloat toHeight;

- (BOOL)mh_canBecomeFirstResponder;    // default is NO
- (BOOL)mh_becomeFirstResponder;
- (BOOL)mh_canResignFirstResponder;    // default is YES
- (BOOL)mh_resignFirstResponder;

@end
