//
//  MHAboutUsViewModel.h
//  WeChat
//
//  Created by senba on 2017/12/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

@interface MHAboutUsViewModel : MHCommonViewModel
/// 软件许可
@property (nonatomic, readonly, strong) RACCommand *softLicenseCommand;
/// 隐私保护
@property (nonatomic, readonly, strong) RACCommand *privateGuardCommand;
@end
