//
//  RACSignal+MHHTTPServiceAdditions.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/7/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

// Convenience category to retreive parsedResults from MHHTTPResponses.
@interface RACSignal (MHHTTPServiceAdditions)
// This method assumes that the receiver is a signal of MHHTTPResponses.
//
// Returns a signal that maps the receiver to become a signal of
// MHHTTPResponses.parsedResult.
- (RACSignal *)mh_parsedResults;
@end
