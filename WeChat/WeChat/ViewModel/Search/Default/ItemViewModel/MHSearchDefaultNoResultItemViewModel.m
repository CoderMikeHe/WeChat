//
//  MHSearchDefaultNoResultItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  没有找到"xxx"相关xxx

#import "MHSearchDefaultNoResultItemViewModel.h"
@interface MHSearchDefaultNoResultItemViewModel ()

/// 显示的富文本
@property (nonatomic, readwrite, copy) NSAttributedString *titleAttr;
/// keyword
@property (nonatomic, readwrite, copy) NSString *keyword;

@end
@implementation MHSearchDefaultNoResultItemViewModel
// 初始化
- (instancetype)initWithKeyword:(NSString *)keyword searchDefaultType:(MHSearchDefaultType)type{
    self = [super init];
    if (self) {
        self.keyword = keyword;
        
        NSString *typeName = @"";
        switch (type) {
            case MHSearchDefaultTypeContacts:
                typeName = @"联系人";
                break;
                
            default:
                break;
        }
        
        NSString *title = [NSString stringWithFormat:@"没有找到\"%@\"相关%@",self.keyword,typeName];
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
        titleAttr.yy_font = MHRegularFont_15;
        titleAttr.yy_color = MHColorFromHexString(@"#b3b3b3");
        titleAttr.yy_alignment = NSTextAlignmentLeft;
        [titleAttr yy_setColor:MHColorFromHexString(@"#4eab5f") range:NSMakeRange(5, keyword.length)];
        self.titleAttr = titleAttr.copy;
    }
    return self;
}

- (CGFloat)cellHeight {
    return 64;
}
@end
