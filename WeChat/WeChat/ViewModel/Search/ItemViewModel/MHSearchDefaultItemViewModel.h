//
//  MHSearchDefaultItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultItemViewModel : NSObject
/// cellHeight default is 40
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/// searchDefaultType
@property (nonatomic, readwrite, assign) MHSearchDefaultType searchDefaultType;

/// searchMore
@property (nonatomic, readwrite, assign, getter=isSearchMore) BOOL searchMore;


@end

NS_ASSUME_NONNULL_END
