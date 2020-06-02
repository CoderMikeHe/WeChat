//
//  MHCommonItemViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  基类 （icon + title + subTitle）

#import <Foundation/Foundation.h>

@interface MHCommonItemViewModel : NSObject
/// 图标
@property (nonatomic, readwrite, copy) NSString *icon;

/// svg 是否是svg default is NO
@property (nonatomic, readwrite, assign, getter=isSvg) BOOL svg;
/// svgTintColor default is nil
@property (nonatomic, readwrite, strong) UIColor *svgTintColor;
/// svgSize
@property (nonatomic, readwrite, assign) CGSize svgSize;

/// 标题
@property (nonatomic, readwrite, copy) NSString *title;
/// 子标题
@property (nonatomic, readwrite, copy) NSString *subtitle;


/// rowHeight , default is 44.0f
@property (nonatomic, readwrite, assign) CGFloat rowHeight;
// default is UITableViewCellSelectionStyleGray.
@property (nonatomic, readwrite, assign) UITableViewCellSelectionStyle selectionStyle;

/// 右边显示的数字标记
@property (nonatomic, readwrite, copy) NSString *badgeValue;

/// 中间偏左icon的图片名字
@property (nonatomic, readwrite, copy) NSString *centerLeftViewName;
/// 中间偏右icon的图片名字
@property (nonatomic, readwrite, copy) NSString *centerRightViewName;
/// 点击这行cell，需要调转到哪个控制器的视图模型 destViewModelClass：必须是SBViewModel的子类
@property (nonatomic, readwrite, assign) Class destViewModelClass;
/// 封装点击这行cell想做的事情
@property (nonatomic, readwrite, copy) void (^operation)(void);

/// init title or icon
+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(NSString *)icon svg:(BOOL)svg;
/// init title
+ (instancetype)itemViewModelWithTitle:(NSString *)title;
@end
