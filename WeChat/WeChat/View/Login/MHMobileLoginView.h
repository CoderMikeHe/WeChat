//
//  MHMobileLoginView.h
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHReactiveView.h"
@interface MHMobileLoginView : UIView<MHReactiveView>
+ (instancetype)mobileLoginView;

/// zoneCodeTextField
@property (weak, nonatomic) IBOutlet UITextField *zoneCodeTextField;

/// phoneTextField
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/// title
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
