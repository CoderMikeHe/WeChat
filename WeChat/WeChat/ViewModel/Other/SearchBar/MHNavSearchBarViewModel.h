//
//  MHNavSearchBarViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/3.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHSearchTypeViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHNavSearchBarViewModel : NSObject
/// height
@property (nonatomic, readonly, assign) CGFloat height;

/// 编辑cmd
@property (nonatomic, readwrite, strong) RACSubject *editSubject;

/// searchType
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;
@end

NS_ASSUME_NONNULL_END
