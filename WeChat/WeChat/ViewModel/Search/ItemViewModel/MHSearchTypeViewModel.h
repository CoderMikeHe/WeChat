//
//  MHSearchTypeViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

// 搜索类型
typedef NS_ENUM(NSInteger, MHSearchType) {
    MHSearchTypeDefault = -1,  // All
    MHSearchTypeMoments = 0,   // 朋友圈
    MHSearchTypeSubscriptions, // 文章
    MHSearchTypeOfficialAccounts, // 公众号
    MHSearchTypeMiniprogram,   // 小程序
    MHSearchTypeMusic,         // 音乐
    MHSearchTypeSticker        // 表情
};


@interface MHSearchTypeViewModel : NSObject

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

@end

NS_ASSUME_NONNULL_END
