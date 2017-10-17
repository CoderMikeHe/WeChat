//
//  MHZoneCodeViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/28.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

@interface MHZoneCodeViewModel : MHTableViewModel
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;

@end
