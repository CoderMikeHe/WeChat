//
//  MHContactsService.m
//  WeChat
//
//  Created by 何千元 on 2020/4/29.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsService.h"


@interface MHContactsService ()
/// contacts
@property (nonatomic, readwrite, copy) NSArray *contacts;
/// contactMappings
@property (nonatomic, readwrite, copy) NSDictionary *contactMappings;
/// girlFriends
@property (nonatomic, readwrite, copy) NSArray *girlFriends;
@end


@implementation MHContactsService

// 单例
MHSingletonM(Instance)

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 获取联系人
        @weakify(self);
        [[self fetchContacts] subscribeNext:^(NSArray *contacts) {
            @strongify(self);
            NSMutableDictionary *contactMappings = [NSMutableDictionary dictionary];
            for (MHUser *contact in contacts) {
                /** 添加解析的单个数据源,id标识符是为了防止重名 */
                [WPFPinYinDataManager addInitializeString:contact.screenName identifer:contact.wechatId model:contact];
                /// 记录 后期通过 wechatId 获取
                [contactMappings setObject:contact forKey:contact.wechatId];
            }
            
            /// 记录数据
            self.contacts = contacts.copy;
            self.contactMappings = contactMappings.copy;
        }];
    }
    return self;
}


/// 获取联系人
-(RACSignal *)fetchContacts {
    
    if (self.contacts && self.contacts.count != 0) {
        return [RACSignal return:self.contacts];
    }

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 读取联系人json
        // 读取路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
        
        // 获取data
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 转换成数据
        NSArray *contatcs = [MHUser modelArrayWithJSON:data];
        
        
        [subscriber sendNext:contatcs];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


// 配置girls
- (NSArray *)girlFriends{
    if (_girlFriends == nil) {
        
        NSMutableArray *girlFriends = [NSMutableArray array];
        
        // 安琪拉
        MHUser *anqila = [MHContactsService sharedInstance].contactMappings[@"anqila"];
        // 不知火舞
        MHUser *buzhihuowu = [MHContactsService sharedInstance].contactMappings[@"buzhihuowu"];
        // 嫦娥
        MHUser *change = [MHContactsService sharedInstance].contactMappings[@"change"];
        // 蔡文姬
        MHUser *caiwenji = [MHContactsService sharedInstance].contactMappings[@"caiwenji"];
        // 貂蝉
        MHUser *diaochan = [MHContactsService sharedInstance].contactMappings[@"diaochan"];
        // 大乔
        MHUser *daqiao = [MHContactsService sharedInstance].contactMappings[@"daqiao"];
        // 妲己
        MHUser *daji = [MHContactsService sharedInstance].contactMappings[@"daji"];
        // 公孙离
        MHUser *gongsunli = [MHContactsService sharedInstance].contactMappings[@"gongsunli"];
        // 花木兰
        MHUser *huamulan = [MHContactsService sharedInstance].contactMappings[@"huamulan"];
        // 伽罗
        MHUser *jialuo = [MHContactsService sharedInstance].contactMappings[@"jialuo"];
        
        [girlFriends addObjectsFromArray:@[anqila,buzhihuowu,change,caiwenji,diaochan,daqiao,daji,gongsunli,huamulan,jialuo]];
        
        
        
        // 镜
        MHUser *jing = [MHContactsService sharedInstance].contactMappings[@"jing"];
        // 露娜
        MHUser *luna = [MHContactsService sharedInstance].contactMappings[@"luna"];
        // 米莱狄
        MHUser *milaidi = [MHContactsService sharedInstance].contactMappings[@"milaidi"];
        // 芈月
        MHUser *miyue = [MHContactsService sharedInstance].contactMappings[@"miyue"];
        // 女娲
        MHUser *nvwa = [MHContactsService sharedInstance].contactMappings[@"nvwa"];
        // 娜可露露
        MHUser *nakelulu = [MHContactsService sharedInstance].contactMappings[@"nakelulu"];
        // 上官婉儿
        MHUser *shangguanwaner = [MHContactsService sharedInstance].contactMappings[@"shangguanwaner"];
        // 沈梦溪
        MHUser *shenmengxi = [MHContactsService sharedInstance].contactMappings[@"shenmengxi"];
        // 孙尚香
        MHUser *sunshangxiang = [MHContactsService sharedInstance].contactMappings[@"sunshangxiang"];
        // 武则天
        MHUser *wuzetian = [MHContactsService sharedInstance].contactMappings[@"wuzetian"];
        
        [girlFriends addObjectsFromArray:@[jing,luna,milaidi,miyue,nvwa,nakelulu,shangguanwaner,shenmengxi,sunshangxiang,wuzetian]];
        
        // 王昭君
        MHUser *wangzhaojun = [MHContactsService sharedInstance].contactMappings[@"wangzhaojun"];
        // 西施
        MHUser *xishi = [MHContactsService sharedInstance].contactMappings[@"xishi"];
        // 小乔
        MHUser *xiaoqiao = [MHContactsService sharedInstance].contactMappings[@"xiaoqiao"];
        // 雅典娜
        MHUser *yadianna = [MHContactsService sharedInstance].contactMappings[@"yadianna"];
        // 杨玉环
        MHUser *yangyuhuan = [MHContactsService sharedInstance].contactMappings[@"yangyuhuan"];
        // 元歌
        MHUser *yuange = [MHContactsService sharedInstance].contactMappings[@"yuange"];
        // 虞姬
        MHUser *yuji = [MHContactsService sharedInstance].contactMappings[@"yuji"];
        // 甄姬
        MHUser *zhenji = [MHContactsService sharedInstance].contactMappings[@"zhenji"];
        // 瑶
        MHUser *yao = [MHContactsService sharedInstance].contactMappings[@"yao"];
        // 钟无艳
        MHUser *zhongwuyan = [MHContactsService sharedInstance].contactMappings[@"zhongwuyan"];
        
        [girlFriends addObjectsFromArray: @[wangzhaojun,xishi,xiaoqiao,yadianna,yangyuhuan,yuange,yuji,zhenji,yao,zhongwuyan]];
        
        // 周瑜
        MHUser *zhouyu = [MHContactsService sharedInstance].contactMappings[@"zhouyu"];
        // 诸葛亮
        MHUser *zhugeliang = [MHContactsService sharedInstance].contactMappings[@"zhugeliang"];
        // 张良
        MHUser *zhangliang = [MHContactsService sharedInstance].contactMappings[@"zhangliang"];
        
        [girlFriends addObjectsFromArray:@[zhouyu,zhugeliang,zhangliang]];
        
        _girlFriends = girlFriends.copy;
    }
    return _girlFriends;
}

@end
