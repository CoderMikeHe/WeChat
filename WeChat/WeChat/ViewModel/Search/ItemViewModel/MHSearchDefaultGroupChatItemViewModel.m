//
//  MHSearchDefaultGroupChatItemViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultGroupChatItemViewModel.h"

@interface MHSearchDefaultGroupChatItemViewModel ()

/// 群聊名称
@property (nonatomic, readwrite, copy) NSString *groupChatName;
/// 子标题
@property (nonatomic, readwrite, copy) NSAttributedString *subtitleAttr;
/// person
@property (nonatomic, readwrite, strong) WPFPerson *person;
/// 群聊用户
@property (nonatomic, readwrite, copy) NSArray *groupUsers;
@end


@implementation MHSearchDefaultGroupChatItemViewModel

- (instancetype)initWithPerson:(WPFPerson *)person groupUsers:(NSArray *)users
{
    self = [super init];
    if (self) {
        self.person = person;
        self.groupUsers = users.copy;
        
        self.groupChatName = [NSString stringWithFormat:@"王者荣耀-%@-交流群 (%ld)",person.name, users.count];
        NSString *subtitle = [NSString stringWithFormat:@"包含:%@",person.name];
        NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:subtitle];
        subtitleAttr.yy_font = MHRegularFont_14;
        subtitleAttr.yy_color = MHColorFromHexString(@"#808080");
        subtitleAttr.yy_alignment = NSTextAlignmentLeft;
        
        NSRange range = NSMakeRange(3 + person.textRange.location, person.textRange.length);
        [subtitleAttr yy_setColor:MHColorFromHexString(@"#4eab5f") range:range];
        self.subtitleAttr = subtitleAttr.copy;
    }
    return self;
}

- (CGFloat)cellHeight {
    return 64.0f;
}
@end
