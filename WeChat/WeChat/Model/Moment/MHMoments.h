//
//  MHMoments.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信朋友圈数据模型

#import "MHObject.h"
#import "MHMoment.h"

//  一组说说
@interface MHMoments : MHObject

/// 多个说说
@property (nonatomic, readwrite, copy) NSArray <MHMoment *> *moments;

@end
