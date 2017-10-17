//
//  MHCommonLabelItemViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  右边显示的内容

#import "MHCommonItemViewModel.h"

@interface MHCommonLabelItemViewModel : MHCommonItemViewModel
/** 右边label显示的内容 */
@property (nonatomic, readwrite, copy) NSString *text;
@end
