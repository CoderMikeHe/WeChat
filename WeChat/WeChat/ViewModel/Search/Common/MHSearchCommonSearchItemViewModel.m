//
//  MHSearchCommonSearchItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/15.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchCommonSearchItemViewModel.h"
@interface MHSearchCommonSearchItemViewModel ()

@property (nonatomic, readwrite, copy) NSAttributedString *titleAttr;

/// title
@property (nonatomic, readwrite, copy) NSString *title;
/// subtitle
@property (nonatomic, readwrite, copy) NSString *subtitle;
/// desc
@property (nonatomic, readwrite, copy) NSString *desc;
/// keyword
@property (nonatomic, readwrite, copy) NSString *keyword;

@end
@implementation MHSearchCommonSearchItemViewModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle desc:(NSString *)desc keyword:(NSString *)keyword {
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.desc = desc;
        self.keyword = keyword;
        
        // 计算富文本
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
        titleAttr.yy_font = MHRegularFont_17;
        titleAttr.yy_color = MHColorFromHexString(@"#191919");
        titleAttr.yy_alignment = NSTextAlignmentLeft;
        [titleAttr yy_setColor:MHColorFromHexString(@"#4eab5f") range:NSMakeRange(0, keyword.length)];
        self.titleAttr = titleAttr.copy;
    }
    return self;
}

@end
