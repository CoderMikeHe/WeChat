//
//  MHMomentItemViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/7/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  单条说说的视图模型

#import <Foundation/Foundation.h>
#import "MHMomentPhotoItemViewModel.h"
#import "MHMomentCommentItemViewModel.h"
#import "MHMomentAttitudesItemViewModel.h"

@interface MHMomentItemViewModel : NSObject


/// ==== Model Properties ====

/// 说说模型
@property (nonatomic, readwrite, strong) MHMoment *moment;

/// 昵称布局
@property (nonatomic, readwrite, strong) YYTextLayout *screenNameLableLayout;
/// 正文布局
@property (nonatomic, readwrite, strong) YYTextLayout *contentLableLayout;
/// 位置
@property (nonatomic, readwrite, strong) YYTextLayout *locationLableLayout;
/// 时间布局
@property (nonatomic, readonly, strong) YYTextLayout *createAtLableLayout;
/// 来源布局
@property (nonatomic, readwrite, strong) YYTextLayout *sourceLableLayout;
/// 配图
@property (nonatomic, readwrite, copy) NSArray <MHMomentPhotoItemViewModel *> *picInfos;


/// 点赞+评论列表 （设计为 可变数组 后期需要添加东西）
@property (nonatomic, readonly, strong) NSMutableArray *dataSource;

/// 辅助属性
/// 是否展开全文
@property (nonatomic, readwrite, assign , getter = isExpand) BOOL expand;


/// cmd
/// 赞cmd
@property (nonatomic, readonly, strong) RACCommand *attitudeOperationCmd;
/// 展开全文/收起
@property (nonatomic, readonly, strong) RACCommand *expandOperationCmd;





/// ==== Frame Properties ====
/// 头像
@property (nonatomic, readwrite, assign) CGRect avatarViewFrame;
/// 昵称
@property (nonatomic, readwrite, assign) CGRect screenNameLableFrame;
/// 正文
@property (nonatomic, readwrite, assign) CGRect contentLableFrame;

/// 时间
@property (nonatomic, readonly, assign) CGRect createAtLableFrame;


/// 位置
@property (nonatomic, readwrite, assign) CGRect locationLableFrame;

/// 来源
@property (nonatomic, readwrite, assign) CGRect sourceLableFrame;

/// 更多按钮
@property (nonatomic, readwrite, assign) CGRect operationMoreBtnFrame;
/// 全文/收起 按钮
@property (nonatomic, readwrite, assign) CGRect expandBtnFrame;
/// 配图View
@property (nonatomic, readwrite, assign) CGRect photosViewFrame;
/// 分享View
@property (nonatomic, readwrite, assign) CGRect shareInfoViewFrame;

/// 箭头
@property (nonatomic, readwrite, assign) CGRect upArrowViewFrame;


/// 整条说说的高度
@property (nonatomic, readwrite, assign) CGFloat height;


/// 事件处理
/// 刷新某一个section的 事件回调
@property (nonatomic, readwrite, strong) RACSubject *reloadSectionSubject;
/// 评论回调
@property (nonatomic, readwrite, strong) RACSubject *commentSubject;


/// 更新 (点赞+评论)
- (void)updateUpArrow;
/// init
- (instancetype)initWithMoment:(MHMoment *)moment;


@end
