//
//  MHSearchMomentsItemViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMomentsItemViewModel.h"
@interface MHSearchMomentsItemViewModel ()
/// avatar 头像 50x50
@property (nonatomic, readwrite, strong) NSURL *profileImageUrl;
/// 用户昵称
@property (nonatomic, readwrite, copy) NSAttributedString *screenNameAttr;
/// person
@property (nonatomic, readwrite, strong) WPFPerson *person;

@end
@implementation MHSearchMomentsItemViewModel
- (instancetype)initWithPerson:(WPFPerson *)person{
    if (self = [super init]) {
        self.person = person;
        MHUser *user = (MHUser *)person.model;
        self.profileImageUrl = user.profileImageUrl;
        NSMutableAttributedString *screenNameAttr = [[NSMutableAttributedString alloc] initWithString:person.name];
        screenNameAttr.yy_font = MHRegularFont_16;
        screenNameAttr.yy_color = MHColorFromHexString(@"#191919");
        screenNameAttr.yy_alignment = NSTextAlignmentLeft;
        [screenNameAttr yy_setColor:MHColorFromHexString(@"#4eab5f") range:person.textRange];
        self.screenNameAttr = screenNameAttr.copy;
    }
    return self;
}
@end
