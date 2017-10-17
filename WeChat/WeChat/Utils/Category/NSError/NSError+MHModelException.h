//
//  NSError+MHModelException.h
//  SenbaEmpty
//
//  Created by senba on 2017/9/30.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MHModelException)
// Creates a new error for an exception that occured during updating an
// MTLModel.
//
// exception - The exception that was thrown while updating the model.
//             This argument must not be nil.
//
// Returns an error that takes its localized description and failure reason
// from the exception.
+ (instancetype)mh_modelErrorWithException:(NSException *)exception;
@end
