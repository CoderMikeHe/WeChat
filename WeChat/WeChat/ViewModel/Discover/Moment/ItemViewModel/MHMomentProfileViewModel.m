//
//  MHMomentProfileViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentProfileViewModel.h"

@interface MHMomentProfileViewModel ()
/// 用户模型
@property (nonatomic, readwrite, strong) MHUser *user;

/// 昵称
@property (nonatomic, readwrite, copy) NSAttributedString *screenNameAttr;


@end

@implementation MHMomentProfileViewModel

- (instancetype)initWithUser:(MHUser *)user
{
    if (self = [super init]) {
        
        /// user
        self.user = user;
        
        /// 假数据
        _unread = 1;
        _unreadUser = [[MHUser alloc] init];
        _unreadUser.avatarLarge = [NSURL URLWithString:@"http://tp2.sinaimg.cn/1401527553/180/5648353790/1"];
        _unreadUser.profileImageUrl = [NSURL URLWithString:@"http://tp2.sinaimg.cn/1401527553/50/5648353790/1"];
        _unreadUser.screenName = @"tombkeeper";
        _unreadUser.idstr = @"1401527553";
        
        /// 设置昵称的外部阴影
        NSMutableAttributedString *screenNameAttr = [[NSMutableAttributedString alloc] initWithString:user.screenName];
        screenNameAttr.yy_alignment = NSTextAlignmentRight;
        screenNameAttr.yy_font = MHMediumFont(20.0f);
        screenNameAttr.yy_color = [UIColor whiteColor];
        YYTextShadow *textShadow = [YYTextShadow new];
        textShadow.color = MHColorFromHexString(@"#212227");
        textShadow.offset = CGSizeMake(1, 2);
        textShadow.radius = 2;
        screenNameAttr.yy_textShadow = textShadow;
        self.screenNameAttr = screenNameAttr;
        
    }
    return self;
}


/// 如果高度是动态的
- (CGFloat)height
{
    if (self.unread>0) {
        ///
        return (MH_SCREEN_WIDTH + 121.0f);
    }
    return (MH_SCREEN_WIDTH+50);
}

- (NSString *)unreadTips
{
    if (self.unread>0) {
        return [NSString stringWithFormat:@"%zd条新消息",self.unread];
    }
    return @"";
}


@end
