//
//  MHFeatureSignatureTextView.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  个性签名 TextView

#import <UIKit/UIKit.h>

@interface MHFeatureSignatureTextView : UIView

+ (instancetype)featureSignatureTextView;

/// 输入框
/// UITextView
@property (nonatomic, readonly, weak) UITextView *textView;
@end
