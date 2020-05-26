//
//  ISRDataHander.h
//  MSC
//
//  Created by ypzhao on 12-11-19.
//  Copyright (c) 2012年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRDataHelper : NSObject

/**
 parse JSON data
 **/
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 parse JSON data for cloud grammar recognition
 **/
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end
