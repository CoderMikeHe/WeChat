//
//  MHSearchCommonSearchItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchCommonSearchItemViewModel : NSObject

@property (nonatomic, readonly, copy) NSAttributedString *titleAttr;
/// title
@property (nonatomic, readonly, copy) NSString *title;
/// subtitle
@property (nonatomic, readonly, copy) NSString *subtitle;
/// desc
@property (nonatomic, readonly, copy) NSString *desc;
/// keyword
@property (nonatomic, readonly, copy) NSString *keyword;

- (instancetype) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle desc:(NSString *)desc keyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
