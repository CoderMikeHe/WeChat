//
//  MHMobileLoginView.m
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMobileLoginView.h"
#import "MHLoginViewModel.h"

@interface MHMobileLoginView ()
/// zoneNameBtn
@property (weak, nonatomic) IBOutlet UIButton *zoneNameBtn;
/// viewModel
@property (nonatomic, readwrite, strong) MHLoginViewModel *viewModel;
@end

@implementation MHMobileLoginView

+ (instancetype)mobileLoginView{
    return [self mh_viewFromXib];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 限制电话号码位数 13 （两个空格）
    [self.phoneTextField mh_limitMaxLength:13];
    /// 限制区域编码 4
    [self.zoneCodeTextField mh_limitMaxLength:4];
    
    /// 添加左侧 leftView
    UILabel *leftView = [UILabel mh_labelWithText:@"+" font:MHMediumFont(17.0f) textColor:[UIColor blackColor]];
    [leftView sizeToFit];
    self.zoneCodeTextField.leftView = leftView;
    self.zoneCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.zoneCodeTextField.text = @"86";
    /// 事件处理
    @weakify(self);
    [[self.zoneNameBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         [self.viewModel.selelctZoneComand execute:nil];
     }];
}

#pragma mark - Public Method
- (void)bindViewModel:(MHLoginViewModel *)viewModel{
    self.viewModel = viewModel;
    
    
}
@end
