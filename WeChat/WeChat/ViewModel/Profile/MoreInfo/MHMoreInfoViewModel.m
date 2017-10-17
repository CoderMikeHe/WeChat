//
//  MHMoreInfoViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMoreInfoViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHFeatureSignatureViewModel.h"
#import "MHLocationViewModel.h"
#import "MHGenderViewModel.h"
@interface MHMoreInfoViewModel ()
/// The current ‘User’
@property (nonatomic, readwrite, strong) MHUser *user;
@end

@implementation MHMoreInfoViewModel

- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = nil;
    
    self.user = [self.services client].currentUser;
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 性别
    MHCommonArrowItemViewModel *gender = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"性别"];
    gender.subtitle = (self.user.gender == MHUserGenderTypeMale)?@"男":@"女";
    @weakify(gender);
    gender.operation = ^{
        @strongify(self);
        @strongify(gender);
        MHGenderViewModel *viewModel = [[MHGenderViewModel alloc] initWithServices:self.services params:@{MHViewModelIDKey:[NSString stringWithFormat:@"%zd",self.user.gender]}];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        
        /// 设置block
        @weakify(self);
        @weakify(gender);
        viewModel.callback = ^(NSString *output) {
            @strongify(self);
            @strongify(gender);
            self.user.gender = output.integerValue;
            [[self.services client] saveUser:self.user];
            gender.subtitle = (self.user.gender == MHUserGenderTypeMale)?@"男":@"女";
            // “手动触发self.dataSource的KVO”，必写。
            [self willChangeValueForKey:@"dataSource"];
            // “手动触发self.now的KVO”，必写。
            [self didChangeValueForKey:@"dataSource"];
        };
    };
    
    /// 区域
    MHCommonArrowItemViewModel *location = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"地区"];
    location.subtitle = @"广东 深圳";
    location.operation = ^{
        @strongify(self);
        MHLocationViewModel *viewModel = [[MHLocationViewModel alloc] initWithServices:self.services params:nil];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
    };
    /// 个性签名
    MHCommonArrowItemViewModel *featureSignature = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"个性签名"];
    featureSignature.subtitle = self.user.featureSignature;
    CGFloat limitWidth = MH_SCREEN_WIDTH - 123.0f - 35.0f;
    CGFloat rowHeight = [featureSignature.subtitle mh_sizeWithFont:MHRegularFont_16 limitWidth:limitWidth].height + 22.0f;
    featureSignature.rowHeight = (rowHeight > 44.0f)?rowHeight:44.0f;
    @weakify(featureSignature);
    featureSignature.operation = ^{
        @strongify(self);
        @strongify(featureSignature);
        NSString *value = MHStringIsNotEmpty(self.user.featureSignature)?self.user.featureSignature:@"";
        MHFeatureSignatureViewModel *viewModel = [[MHFeatureSignatureViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey:value}];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        /// 设置block
        @weakify(self);
        @weakify(featureSignature);
        viewModel.callback = ^(NSString *output) {
            @strongify(self);
            @strongify(featureSignature);
            self.user.featureSignature = output;
            [[self.services client] saveUser:self.user];
            featureSignature.subtitle = output;
            CGFloat rowHeight = [featureSignature.subtitle mh_sizeWithFont:MHRegularFont_16 limitWidth:limitWidth].height + 22.0f;
            featureSignature.rowHeight = (rowHeight > 44.0f)?rowHeight:44.0f;
            // “手动触发self.dataSource的KVO”，必写。
            [self willChangeValueForKey:@"dataSource"];
            // “手动触发self.now的KVO”，必写。
            [self didChangeValueForKey:@"dataSource"];
        };
    };
    
    
    /// 更多
    group0.itemViewModels = @[gender , location , featureSignature];
    self.dataSource = @[group0];
}
@end
