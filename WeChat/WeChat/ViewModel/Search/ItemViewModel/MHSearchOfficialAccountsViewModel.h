//
//  MHSearchOfficialAccountsViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/8.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchOfficialAccountsViewModel : NSObject

/// officialAccountTapCommand
@property (nonatomic, readwrite, strong) RACCommand *officialAccountTapCommand;

@end

NS_ASSUME_NONNULL_END
