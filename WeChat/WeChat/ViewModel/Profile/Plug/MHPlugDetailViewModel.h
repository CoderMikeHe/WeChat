//
//  MHPlugDetailViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"

@interface MHPlugDetailViewModel : MHViewModel
/// type
@property (nonatomic, readonly, assign) MHPlugDetailType type;

/// feedbackCommand
@property (nonatomic, readonly, strong) RACCommand *feedbackCommand;
@end
