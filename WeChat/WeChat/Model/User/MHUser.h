//
//  MHUser.h
//  WeChat
//
//  Created by senba on 2017/10/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用户信息模型


#import "MHObject.h"
@interface MHUser : MHObject
/// 昵称
@property (nonatomic, readwrite, copy) NSString *screenName;
/// id
@property (nonatomic, readwrite, copy) NSString *idstr;
/// avatar 头像 50x50
@property (nonatomic, readwrite, strong) NSURL *profileImageUrl;
/// avatar large 180 x 180
@property (nonatomic, readwrite, strong) NSURL *avatarLarge;
/// 封面URL
@property (nonatomic, readwrite, strong) NSURL *coverImageUrl;
/// UIImage (PS:这里就假设我们已经通过coverImageUrl将图片下载到本地了)
@property (nonatomic, readwrite, strong) UIImage *coverImage;

/// 个性签名
@property (nonatomic, readwrite, copy) NSString *featureSignature;

/// 用户性别 0 - 男 1 - 女
@property (nonatomic, readwrite, assign) MHUserGenderType gender;

/// ----- 登录相关 -----
/// qq
@property (nonatomic, readwrite, copy) NSString *qq;
/// 邮箱
@property (nonatomic, readwrite, copy) NSString *email;
/// 微信号
@property (nonatomic, readwrite, copy) NSString *wechatId;
/// 手机号码
@property (nonatomic, readwrite, copy) NSString *phone;

/// 登录渠道
@property (nonatomic, readwrite, assign) MHUserLoginChannelType channel;
@end
