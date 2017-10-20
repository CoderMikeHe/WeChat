//
//  MHMainFrameItemViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHLiveRoom.h"
@interface MHMainFrameItemViewModel : NSObject

/// LiveRoom
@property (nonatomic, readonly, strong) MHLiveRoom *liveRoom;

/// girlStar
@property (nonatomic, readonly, copy) NSString *girlStar;

/// 观众人数
@property (nonatomic, readonly, copy) NSAttributedString *allNumAttr;

/// cellHeight
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/// init
- (instancetype)initWithLiveRoom:(MHLiveRoom *)liveRoom;
@end
