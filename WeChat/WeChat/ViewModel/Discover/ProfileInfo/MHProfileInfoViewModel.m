//
//  MHProfileInfoViewModel.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHProfileInfoViewModel.h"

@interface MHProfileInfoViewModel ()
/// user
@property (nonatomic, readwrite, strong) MHUser *user;
/// pictures
@property (nonatomic, readwrite, copy) NSArray *pictures;
/// 是否是当前用户
@property (nonatomic, readwrite, assign) BOOL currentUser;
@end

@implementation MHProfileInfoViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.user = params[MHViewModelUtilKey];
        self.currentUser = [self.user.idstr isEqualToString:services.client.currentUser.idstr];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    self.title = @"详细资料";
    
    /// 配置假数据
    NSArray *pics = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517306114018&di=c7dd8193db22d4283e5085690d94b608&imgtype=0&src=http%3A%2F%2Fwww.faxingzhan.com%2Fuploads%2Fallimg%2F161025%2F65-1610251002050-L.jpg%3F150_200",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517307319889&di=0b925051bfcd3c4da7b0ddbaf048b271&imgtype=0&src=http%3A%2F%2Fmp0.qiyipic.com%2Fimage%2F20171201%2Fdf%2Faa%2Fppu_202035620102_pp_601_300_300.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517306506011&di=011d847149ff06da6d7ec6babef36bc6&imgtype=0&src=http%3A%2F%2Fmp1.qiyipic.com%2Fimage%2F20180112%2F3d%2Fe4%2Fppu_257951910102_pp_601_300_300.jpg",@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1355253485,2273621930&fm=27&gp=0.jpg"];
    /// 随机生成图片
    NSInteger count = [NSObject mh_randomNumberWithFrom:0 to:4];
    NSMutableArray *pictures = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < count; i++) {
        [pictures addObject:pics[i]];
    }
    self.pictures = pictures.copy;
}

@end
