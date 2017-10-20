//
//  MHMainFrameViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHMainFrameItemViewModel.h"

@interface MHMainFrameViewModel : MHTableViewModel

/// 商品数组 <MHLiveRoom *>
@property (nonatomic, readonly, copy) NSArray *liveRooms;

@end
