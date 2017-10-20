//
//  NSError+MHExtension.h
//  WeChat
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MHExtension)
+ (NSString *)mh_tipsFromError:(NSError *)error;
@end
