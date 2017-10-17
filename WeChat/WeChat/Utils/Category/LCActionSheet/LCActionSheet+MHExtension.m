//
//  LCActionSheet+MHExtension.m
//  SenbaUsed
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "LCActionSheet+MHExtension.h"

@implementation LCActionSheet (MHExtension)
+ (void)mh_configureActionSheet
{
    LCActionSheetConfig *config = LCActionSheetConfig.config;
    
    /// 蒙版可点击
    config.darkViewNoTaped = NO;
    config.separatorColor = MH_MAIN_LINE_COLOR_1;
    config.buttonColor = [UIColor colorFromHexString:@"#3C3E44"];
    config.buttonFont = MHRegularFont_16;
    config.unBlur = YES;
    config.darkOpacity = .6f;
 
    /// 设置
    config.titleEdgeInsets = UIEdgeInsetsMake(27, 22, 27, 22);
    config.titleFont = MHRegularFont_13;
    
}
@end
