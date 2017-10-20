//
//  NSError+MHModelException.m
//  WeChat
//
//  Created by senba on 2017/9/30.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import "NSError+MHModelException.h"

// The domain for errors originating from MHModel.
static NSString * const MHModelErrorDomain = @"MHModelErrorDomain";

// An exception was thrown and caught.
static const NSInteger MHModelErrorExceptionThrown = 1;

// Associated with the NSException that was caught.
static NSString * const MHModelThrownExceptionErrorKey = @"MHModelThrownException";

@implementation NSError (MHModelException)

+ (instancetype)mh_modelErrorWithException:(NSException *)exception {
    NSParameterAssert(exception != nil);
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: exception.description,
                               NSLocalizedFailureReasonErrorKey: exception.reason,
                               MHModelThrownExceptionErrorKey: exception
                               };
    
    return [NSError errorWithDomain:MHModelErrorDomain code:MHModelErrorExceptionThrown userInfo:userInfo];
}

@end
