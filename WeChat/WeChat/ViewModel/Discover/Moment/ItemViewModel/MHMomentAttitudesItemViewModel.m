//
//  MHMomentAttitudesItemViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentAttitudesItemViewModel.h"
#import "MHHTTPService.h"
@interface MHMomentAttitudesItemViewModel ()
/// 单条说说
@property (nonatomic, readwrite, strong) MHMoment *moment;

/// 执行更新数据的命令
@property (nonatomic, readwrite, strong) RACCommand *operationCmd;

/// container
@property (nonatomic, readwrite, strong) YYTextContainer *container;

/// 富文本
@property (nonatomic, readwrite, strong) NSMutableAttributedString *attitudesAttr;

@end

@implementation MHMomentAttitudesItemViewModel

- (instancetype)initWithMoment:(MHMoment *)moment
{
    if (self = [super init]) {
        
        self.moment = moment;
        self.type = MHMomentContentTypeAttitude;
        
        UIFont *font = MHMomentCommentScreenNameFont;
        /// 拼接 昵称 （吴亦凡，鹿晗....）
        for (MHUser *user in self.moment.attitudesList) {
            NSMutableAttributedString *screenNameAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@，",user.screenName]];
            screenNameAttr.yy_color = WXGlobalBlackTextColor;
            screenNameAttr.yy_font = MHMomentCommentContentFont;
            /// 设置昵称高亮
            NSRange range = NSMakeRange(0, user.screenName.length);
            [screenNameAttr yy_setColor:MHMomentScreenNameTextColor range:range];
            [screenNameAttr yy_setFont:font range:range];
            
            /// 点击的高亮的
            YYTextBorder *border = [YYTextBorder new];
            border.cornerRadius = 0;
            border.insets = UIEdgeInsetsMake(0, -1, 0, -1);
            border.fillColor = MHMomentTextHighlightBackgroundColor;
            /// 点击高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            // 将用户数据带出去
            highlight.userInfo = @{MHMomentUserInfoKey:user};
            [highlight setBackgroundBorder:border];
            [screenNameAttr yy_setTextHighlight:highlight range:range];
            
            /// 拼接
            [self.attitudesAttr appendAttributedString:screenNameAttr];
        }
        
        /// 去掉最后一个 ，
        [self.attitudesAttr deleteCharactersInRange:NSMakeRange(self.attitudesAttr.length-1, 1)];
        
        /// 统一配置
        self.attitudesAttr.yy_lineBreakMode = NSLineBreakByCharWrapping;
        self.attitudesAttr.yy_alignment = NSTextAlignmentLeft;
        
        
        /// 文本布局
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:self.container text:self.attitudesAttr.copy];
        self.contentLableLayout = layout;
        self.contentLableFrame = CGRectMake(MHMomentCommentViewContentLeftOrRightInset, MHMomentCommentViewAttitudesTopOrBottomInset, layout.textBoundingSize.width, layout.textBoundingSize.height);
        self.cellHeight = layout.textBoundingSize.height + 2*MHMomentCommentViewAttitudesTopOrBottomInset;

        /// 初始化一些命令
        [self initialize];
    }
    
    return self;
}


- (void)initialize
{
    /// 更行布局的属性
    @weakify(self);
    self.operationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(MHMoment * input) {
        @strongify(self);
        BOOL isAppend = input.attitudesStatus>0;
        /// 拼接一个，目的是为了后面 删除和添加
        [self.attitudesAttr yy_appendString:@"，"];
        /// 需要拼接或删除的用户
        MHUser *user = [MHHTTPService sharedInstance].currentUser;
        
        if (isAppend) {
            /// 拼接 “吴亦凡”
            NSMutableAttributedString *screenNameAttr = [[NSMutableAttributedString alloc] initWithString:user.screenName];
            screenNameAttr.yy_color = MHMomentScreenNameTextColor;
            screenNameAttr.yy_font = MHMomentCommentScreenNameFont;
            /// 点击的高亮的
            YYTextBorder *border = [YYTextBorder new];
            border.cornerRadius = 0;
            border.insets = UIEdgeInsetsMake(0, -1, 0, -1);
            border.fillColor = MHMomentTextHighlightBackgroundColor;
            /// 点击高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            // 将用户数据带出去
            highlight.userInfo = @{MHMomentUserInfoKey:user};
            [highlight setBackgroundBorder:border];
            [screenNameAttr yy_setTextHighlight:highlight range:screenNameAttr.yy_rangeOfAll];
            [self.attitudesAttr appendAttributedString:screenNameAttr];
        }else{
            /// 移除 "吴亦凡，"
            NSString *screenName = [NSString stringWithFormat:@"%@，",user.screenName];
            NSRange range = [self.attitudesAttr.string rangeOfString:screenName];
            if (range.location != NSNotFound){
                [self.attitudesAttr deleteCharactersInRange:range];
            }
            
            /// 由于之前拼接了`，`这里还需要移除`，`
            /// 去掉最后一个 ，
            [self.attitudesAttr deleteCharactersInRange:NSMakeRange(self.attitudesAttr.length-1, 1)];
            
        }
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:self.container text:self.attitudesAttr.copy];
        self.contentLableLayout = layout;
        self.contentLableFrame = CGRectMake(MHMomentCommentViewContentLeftOrRightInset, MHMomentCommentViewAttitudesTopOrBottomInset, layout.textBoundingSize.width, layout.textBoundingSize.height);
        self.cellHeight = layout.textBoundingSize.height + 2*MHMomentCommentViewAttitudesTopOrBottomInset;
        return [RACSignal empty];
    }];
    
    self.operationCmd.allowsConcurrentExecution = YES;
}


#pragma mark - Getter

- (YYTextContainer *)container
{
    if (_container == nil) {
        CGFloat limitWidth = MHMomentCommentViewWidth()-2*MHMomentCommentViewContentLeftOrRightInset;
        _container = [YYTextContainer containerWithSize:CGSizeMake(limitWidth, MAXFLOAT)];
        _container.maximumNumberOfRows = 0;
    }
    return _container;
}

- (NSMutableAttributedString *)attitudesAttr
{
    if (_attitudesAttr == nil) {
        _attitudesAttr = [[NSMutableAttributedString alloc] init];
        UIFont *font = MHMomentCommentScreenNameFont;
        //// 默认拼接 “❤️  ”
        /// 爱心 ❤️
        UIImage *likeImage = [UIImage imageNamed:@"wx_albumInformationLikeHL_15x15"];
        likeImage = [UIImage imageWithCGImage:likeImage.CGImage scale:[UIScreen screenScale] orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachLikeText = [NSMutableAttributedString yy_attachmentStringWithContent:likeImage contentMode:UIViewContentModeCenter attachmentSize:likeImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [self.attitudesAttr appendAttributedString:attachLikeText];
        /// 拼接一个空格
        NSMutableAttributedString *marginAttr = [[NSMutableAttributedString alloc] initWithString:@"  "];
        [self.attitudesAttr appendAttributedString:marginAttr];
    }
    return _attitudesAttr;
}

@end
