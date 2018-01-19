//
//  MHMomentCommentItemViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentCommentItemViewModel.h"

@interface MHMomentCommentItemViewModel ()

/// 评论模型
@property (nonatomic, readwrite, strong) MHComment *comment;

@end

@implementation MHMomentCommentItemViewModel

- (instancetype)initWithComment:(MHComment *)comment
{
    if (self = [super init]) {
        
        self.comment = comment;
        self.type = MHMomentContentTypeComment;
        
        /// 正文
        NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] init];
        
        /// : 正文富文本 （还需要匹配超链接 表情 电话号码 @xx）
        NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"：%@",comment.text]];
        textAttr.yy_color = WXGlobalBlackTextColor;
        textAttr.yy_font = MHMomentCommentContentFont;
        
        /// 点击的高亮的
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 0;
        border.insets = UIEdgeInsetsMake(0, -1, 0, -1);
        border.fillColor = MHMomentTextHighlightBackgroundColor;
        
        /// XXX （来源）
        NSMutableAttributedString *fromAttr = [[NSMutableAttributedString alloc] initWithString:comment.fromUser.screenName];
        fromAttr.yy_color = MHMomentScreenNameTextColor;
        fromAttr.yy_font = MHMomentCommentScreenNameFont;
        /// 点击高亮
        YYTextHighlight *fromHighlight = [YYTextHighlight new];
        // 将用户数据带出去
        fromHighlight.userInfo = @{MHMomentUserInfoKey:comment.fromUser};
        [fromHighlight setBackgroundBorder:border];
        [fromAttr yy_setTextHighlight:fromHighlight range:fromAttr.yy_rangeOfAll];
        
    
        /// 是否有 回复xxx
        if (comment.toUser) {
            /// 回复
            NSMutableAttributedString *replyAttr = [[NSMutableAttributedString alloc] initWithString:@"回复"];
            replyAttr.yy_color = textAttr.yy_color;
            replyAttr.yy_font = textAttr.yy_font;
            
            /// xxx（目标）
            NSMutableAttributedString *toAttr = [[NSMutableAttributedString alloc] initWithString:comment.toUser.screenName];
            toAttr.yy_color = fromAttr.yy_color;
            toAttr.yy_font = fromAttr.yy_font;
            /// 高亮
            YYTextHighlight *toHighlight = [[YYTextHighlight alloc] init];
            [toHighlight setBackgroundBorder:border];
            /// 将用户数据带出去
            toHighlight.userInfo = @{MHMomentUserInfoKey:comment.toUser};
            [toAttr yy_setTextHighlight:toHighlight range:toAttr.yy_rangeOfAll];
            
            /// 拼接数据 (A回复B)
            [replyAttr appendAttributedString:toAttr];
            [fromAttr appendAttributedString:replyAttr];
        }
        
        /// 拼接 （A回复B：xxxx   或者  A：xxxx）
        [contentAttr appendAttributedString:fromAttr];
        [contentAttr appendAttributedString:textAttr];
        
        /// 统一配置
        contentAttr.yy_lineBreakMode = NSLineBreakByCharWrapping;
        contentAttr.yy_alignment = NSTextAlignmentLeft;
        
        /// 文本布局
        CGFloat limitWidth = MHMomentCommentViewWidth()-2*MHMomentCommentViewContentLeftOrRightInset;
        YYTextContainer *contentLableContainer = [YYTextContainer containerWithSize:CGSizeMake(limitWidth, MAXFLOAT)];
        contentLableContainer.maximumNumberOfRows = 0;
        YYTextLayout *contentLableLayout = [YYTextLayout layoutWithContainer:contentLableContainer text:contentAttr.copy];
        self.contentLableLayout = contentLableLayout;
        
        
        /// ----------- 尺寸属性 -----------
        CGFloat contentLableW = contentLableLayout.textBoundingSize.width;
        CGFloat contentLableH = contentLableLayout.textBoundingSize.height;
        self.contentLableFrame = CGRectMake(MHMomentCommentViewContentLeftOrRightInset, MHMomentCommentViewContentTopOrBottomInset, contentLableW, contentLableH);
        self.cellHeight = CGRectGetMaxY(self.contentLableFrame)+MHMomentCommentViewContentTopOrBottomInset;
    }
    
    return self;
}
@end
