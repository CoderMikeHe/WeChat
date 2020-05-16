//
//  MHSearchCommonRelatedItemViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  通用搜索vm

#import "MHSearchCommonRelatedItemViewModel.h"
@interface MHSearchCommonRelatedItemViewModel ()
@property (nonatomic, readwrite, copy) NSAttributedString *titleAttr;

/// title
@property (nonatomic, readwrite, copy) NSString *title;
/// keyword
@property (nonatomic, readwrite, copy) NSString *keyword;

@end
@implementation MHSearchCommonRelatedItemViewModel
- (instancetype)initWithTitle:(NSString *)title keyword:(NSString *)keyword {
    if (self = [super init]) {
        self.title = title;
        self.keyword = keyword;
        
        // 计算富文本
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
        titleAttr.yy_font = MHRegularFont_17;
        titleAttr.yy_color = MHColorFromHexString(@"#191919");
        titleAttr.yy_alignment = NSTextAlignmentLeft;
        [titleAttr yy_setColor:MHColorFromHexString(@"#808080") range:NSMakeRange(0, keyword.length)];
        self.titleAttr = titleAttr.copy;
    }
    return self;
}
@end
