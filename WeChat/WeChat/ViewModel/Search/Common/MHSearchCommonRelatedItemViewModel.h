//
//  MHSearchCommonRelatedItemViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchCommonRelatedItemViewModel : NSObject
/// MHSearchModeRelated 场景下 点击关联符号的事件
@property (nonatomic, readwrite, strong) RACCommand *relatedKeywordCommand;


@property (nonatomic, readonly, copy) NSAttributedString *titleAttr;
/// title
@property (nonatomic, readonly, copy) NSString *title;
/// keyword
@property (nonatomic, readonly, copy) NSString *keyword;

- (instancetype)initWithTitle:(NSString *)title keyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
