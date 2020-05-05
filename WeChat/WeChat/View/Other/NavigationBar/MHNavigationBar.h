//
//  MHNavigationBar.h
//  WeChat
//
//  Created by 何千元 on 2020/5/4.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// rightButton
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


// 初始化
+ (instancetype)navigationBar;
@end

NS_ASSUME_NONNULL_END
