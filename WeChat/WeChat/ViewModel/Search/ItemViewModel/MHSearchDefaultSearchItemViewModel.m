//
//  MHSearchDefaultSearchItemViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/25.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultSearchItemViewModel.h"


@interface MHSearchDefaultSearchItemViewModel ()

/// searchKeyword
@property (nonatomic, readwrite, copy) NSString *searchKeyword;
/// 搜一搜 xx
@property (nonatomic, readwrite, copy) NSAttributedString *titleAttr;
/// subtitle
@property (nonatomic, readwrite, copy) NSString *subtitle;

/// keyword
@property (nonatomic, readwrite, copy) NSString *keyword;
/// 是否是搜一搜
@property (nonatomic, readwrite, assign) BOOL isSearch;

@end


@implementation MHSearchDefaultSearchItemViewModel


- (instancetype)initWithKeyWord:(NSString *)keyword searchKeyword:(NSString *)searchKeyword search:(BOOL)isSearch{
    self = [super init];
    if (self) {
        self.keyword = keyword;
        self.isSearch = isSearch;
        self.searchKeyword = searchKeyword;
        self.searchDefaultType = MHSearchDefaultTypeSearch;
        if (isSearch) {
            // 搜一搜模式
            NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"搜一搜 %@",keyword]];
            titleAttr.yy_font = MHRegularFont_17;
            titleAttr.yy_color = MHColorFromHexString(@"#1A1A1A");
            titleAttr.yy_alignment = NSTextAlignmentLeft;
            NSRange range = NSMakeRange(4, keyword.length);
            [titleAttr yy_setColor:MHColorFromHexString(@"#4eab5f") range:range];
            self.titleAttr = titleAttr.copy;
            
            // subtitle
            self.subtitle = @"小程序、朋友圈、公众号、文章等";
        }
        
    }
    return self;
}


- (CGFloat)cellHeight {
    return self.isSearch?72.0f:51.0f;
}

@end
