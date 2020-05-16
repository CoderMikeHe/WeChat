//
//  MHSearch.m
//  WeChat
//
//  Created by 何千元 on 2020/5/16.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearch.h"

@implementation MHSearch
+ (instancetype) searchWithKeyword:(NSString *)keyword searchMode:(MHSearchMode)searchMode{
    return [[MHSearch alloc] initWithKeyword:keyword searchMode:searchMode];
}
- (instancetype) initWithKeyword:(NSString *)keyword searchMode:(MHSearchMode)searchMode {
    if (self = [super init]) {
        _keyword = keyword;
        _searchMode = searchMode;
    }
    return self;
}
@end
