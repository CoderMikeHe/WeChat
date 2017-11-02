//
//  MHURLParameters.m
//  WeChat
//
//  Created by senba on 2017/7/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHURLParameters.h"
#import "MHHTTPService.h"


@implementation SBURLExtendsParameters

+ (instancetype)extendsParameters
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)ver{
    static NSString *version = nil;
    if (version == nil) version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return (version.length>0)?version:@"";
}

- (NSString *)token {
//    NSString *uid = self.uid;
//    if (MHStringIsNotEmpty(uid) && MHStringIsNotEmpty([MHHTTPService sharedInstance].token)){
//        NSString *t_token = [NSString stringWithFormat:@"%@-%@",uid,[MHHTTPService sharedInstance].token];
//        return t_token;
//    }
    return @"";//[MHHTTPService sharedInstance].token;
}

- (NSString *)deviceid {
    static NSString *deviceidStr = nil;
    if (deviceidStr == nil) deviceidStr = [SAMKeychain deviceId];
    return deviceidStr.length>0?deviceidStr:@"";
}

- (NSString *)platform{
    return @"iOS";
}

- (NSString *)channel{
    return @"AppStore";
}

- (NSString *)t {
    return [NSString stringWithFormat:@"%.f", [NSDate date].timeIntervalSince1970];
}

@end

@implementation MHURLParameters

+(instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self alloc] initUrlParametersWithMethod:method path:path parameters:parameters];
}

-(instancetype)initUrlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        self.method = method;
        self.path = path;
        self.parameters = parameters;
        self.extendsParameters = [[SBURLExtendsParameters alloc] init];
    }
    return self;
}
@end
