//
//  MHSearch.h
//  WeChat
//
//  Created by 何千元 on 2020/5/16.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHSearch : MHObject
/// keyword
@property (nonatomic, readwrite, copy) NSString *keyword;
/// searchMode
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;
+ (instancetype) searchWithKeyword:(NSString *)keyword searchMode:(MHSearchMode)searchMode;
- (instancetype) initWithKeyword:(NSString *)keyword searchMode:(MHSearchMode)searchMode;
@end

NS_ASSUME_NONNULL_END
