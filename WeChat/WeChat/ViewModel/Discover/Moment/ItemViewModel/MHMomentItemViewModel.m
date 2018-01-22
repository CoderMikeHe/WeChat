//
//  MHMomentItemViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentItemViewModel.h"
#import "MHMomentHelper.h"
#import "MHEmoticonManager.h"
#import "MHHTTPService.h"
#import "NSMutableAttributedString+MHMoment.h"
@interface MHMomentItemViewModel ()
/// 赞cmd
@property (nonatomic, readwrite, strong) RACCommand *attitudeOperationCmd;
/// 展开全文cmd
@property (nonatomic, readwrite, strong) RACCommand *expandOperationCmd;
@end


@implementation MHMomentItemViewModel
- (instancetype)initWithMoment:(MHMoment *)moment
{
    if (self = [super init]) {
#if 1
        /// 内容宽度
        CGFloat limitWidth = MHMomentCommentViewWidth();
        
        /// 单行文字公有一个container
        YYTextContainer *singleRowContainer = [YYTextContainer containerWithSize:YYTextContainerMaxSize];
        singleRowContainer.maximumNumberOfRows = 1;
        
        /// 高亮背景
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 0;
        border.insets = UIEdgeInsetsMake(0, -1, 0, -1);
        border.fillColor = MHMomentTextHighlightBackgroundColor;
        
        /// ----------- 模型属性 -----------
        self.moment = moment;
        
        /// 昵称
        if (MHStringIsNotEmpty(moment.user.screenName)) {
            /// 富文本
            NSMutableAttributedString *screenNameAttr = [[NSMutableAttributedString alloc] initWithString:moment.user.screenName];
            screenNameAttr.yy_font = MHMomentScreenNameFont;
            screenNameAttr.yy_color = MHMomentScreenNameTextColor;
            screenNameAttr.yy_lineBreakMode = NSLineBreakByCharWrapping;
            screenNameAttr.yy_alignment = NSTextAlignmentLeft;
            /// 设置高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            /// 传递点击事件需要的数据
            highlight.userInfo = @{MHMomentUserInfoKey:moment.user};
            [highlight setBackgroundBorder:border];
            [screenNameAttr yy_setTextHighlight:highlight range:screenNameAttr.yy_rangeOfAll];
            /// 实现布局好宽高 以及属性
            YYTextContainer *screenNameLableContainer = [YYTextContainer containerWithSize:CGSizeMake(limitWidth, MAXFLOAT)];
            screenNameLableContainer.maximumNumberOfRows = 1;
            YYTextLayout *screenNameLableLayout = [YYTextLayout layoutWithContainer:screenNameLableContainer text:screenNameAttr.copy];
            self.screenNameLableLayout = screenNameLableLayout;
        }
        
        /// 正文有值
        if (MHStringIsNotEmpty(moment.text)){
            NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:moment.text];
            textAttr.yy_font = MHMomentContentFont;
            textAttr.yy_color = MHMomentContentTextColor;
            textAttr.yy_lineBreakMode = NSLineBreakByCharWrapping;
            textAttr.yy_alignment = NSTextAlignmentLeft;
            
            /// 去正则匹配
            [textAttr mh_regexContentWithWithEmojiImageFontSize:15];
            
            /// 实现布局好宽高 以及属性
            /// PS:用这个方法计算尺寸 要比 [self.textAttr mh_sizeWithLimitWidth:limitWidth]这个计算的值要准确的多
            YYTextContainer *contentLableContainer = [YYTextContainer containerWithSize:CGSizeMake(limitWidth, MAXFLOAT)];
            contentLableContainer.maximumNumberOfRows = 0;
            YYTextLayout *contentLableLayout = [YYTextLayout layoutWithContainer:contentLableContainer text:textAttr.copy];
            self.contentLableLayout = contentLableLayout;
        }
        
        /// 配图
        self.picInfos = [moment.picInfos.rac_sequence map:^MHMomentPhotoItemViewModel *(MHPicture * picture) {
            MHMomentPhotoItemViewModel *viewModel = [[MHMomentPhotoItemViewModel alloc] initWithPicture:picture];
            return viewModel;
        }].array;
        
        
        /// 位置
        if (MHStringIsNotEmpty(self.moment.location)) {
            /// 富文本
            NSMutableAttributedString *location  = [[NSMutableAttributedString alloc] initWithString:self.moment.location];
            location.yy_font = MHMomentCreatedAtFont;
            location.yy_color = MHMomentScreenNameTextColor;
            /// 高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:border];
            /// 传递数据
            highlight.userInfo = @{MHMomentLocationNameKey : self.moment.location};
            [location yy_setTextHighlight:highlight range:location.yy_rangeOfAll];
            /// 布局
            YYTextLayout *locationLableLayout = [YYTextLayout layoutWithContainer:singleRowContainer text:location.copy];
            self.locationLableLayout = locationLableLayout;
        }
        
        /// 来源(考虑到来源可能会被电击 这里设置为富文本)
        if (MHStringIsNotEmpty(self.moment.source)) {
            NSMutableAttributedString *source  = [[NSMutableAttributedString alloc] initWithString:self.moment.source];
            source.yy_font = MHMomentCreatedAtFont;
            source.yy_color = MHMomentCreatedAtTextColor;
            if (self.moment.sourceAllowClick > 0 && self.moment.sourceUrl.length>0) {
                /// 允许点击
                source.yy_color = MHMomentScreenNameTextColor;
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:border];
                /// 传递数据
                if (self.moment.sourceUrl) highlight.userInfo = @{MHMomentLinkUrlKey : self.moment.sourceUrl};
                [source yy_setTextHighlight:highlight range:source.yy_rangeOfAll];
            }
            
            YYTextLayout *sourceLableLayout = [YYTextLayout layoutWithContainer:singleRowContainer text:source.copy];
            self.sourceLableLayout = sourceLableLayout;
        }
        
        /// 评论列表
        NSMutableArray *ops = [NSMutableArray array];
        //// 点赞列表
        if(self.moment.attitudesList.count>0)
        {
            /// 需要
            MHMomentAttitudesViewModel *attitudes = [[MHMomentAttitudesViewModel alloc] initWithMoment:moment];
            [ops addObject:attitudes];
            
        }
        if (self.moment.commentsList.count>0) {
            
            [ops addObjectsFromArray:[self.moment.commentsList.rac_sequence map:^MHMomentCommentItemViewModel *(MHComment * comment) {
                MHMomentCommentItemViewModel *viewModel = [[MHMomentCommentItemViewModel alloc] initWithComment:comment];
                return viewModel;
            }].array];
        }
        
        
        self.operationMores = ops.copy;
        
        
        /// ----------- 尺寸属性 -----------
        /// 头像
        CGFloat avatarViewX = MHMomentContentLeftOrRightInset;
        CGFloat avatarViewY = MHMomentContentTopInset;
        CGFloat avatarViewW = MHMomentAvatarWH;
        CGFloat avatarViewH = MHMomentAvatarWH;
        self.avatarViewFrame = CGRectMake(avatarViewX, avatarViewY, avatarViewW, avatarViewH);
        
        /// 昵称
        CGFloat screenNameLableX = CGRectGetMaxX(self.avatarViewFrame)+MHMomentContentInnerMargin;
        CGFloat screenNameLableY = avatarViewY;
        CGFloat screenNameLableW = self.screenNameLableLayout.textBoundingSize.width;
        CGFloat screenNameLableH = self.screenNameLableLayout.textBoundingSize.height;
        self.screenNameLableFrame = CGRectMake(screenNameLableX, screenNameLableY, screenNameLableW, screenNameLableH);
  
        /// 由于要点击 全文/展开 更新子控件的尺寸 , 故抽取出来
        [self _updateSubviewsFrameWithExpand:NO];
        
        ////  ---------- 初始化单条说说的上的所有事件处理 ------------
        [self initialize];
#endif
    }
    return self;
}




#pragma mark - 初始化所有后面事件将要执行的命令
- (void)initialize{
    /// 用户点赞执行的cmd
    @weakify(self);
    self.attitudeOperationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * input) {
        @strongify(self);
        /// 处理点赞
        if (self.moment.attitudesStatus<=0) {
            /// 未点赞，则点赞 >0即可
            self.moment.attitudesStatus = 1;
            self.moment.attitudesCount = self.moment.attitudesCount+1;
            
            [self.moment.attitudesList addObject:[MHHTTPService sharedInstance].currentUser];
        }else{
            /// 已点赞，则取消点赞
            self.moment.attitudesStatus = 0;
            self.moment.attitudesCount = self.moment.attitudesCount-1;
            if (self.moment.attitudesCount<0) self.moment.attitudesCount=0;
            /**
             CodeMikeHe👉这里要注意： 数组调用removeObject方法，底层是会挨个取出数据数组里面的`每个元素`与`传入的数据`比对isEqual 。笔者在MHUser中重写isEqual了比对规则
             /// 实现 MHUser.m
             - (BOOL)isEqual:(MHUser *)object
             {
             /// 重写比对规则
             if([object isKindOfClass:[self class]])
             {
             return [self.idstr isEqualToString:object.idstr];
             }
             return [super isEqual:object];
             }
             */
            [self.moment.attitudesList removeObject:[MHHTTPService sharedInstance].currentUser];
        }
        
        /// 0. 还需要判断 self.moment.attitudesList.count > 0 则self.operationMores = nil
        /// 1. 取出operationMores的第一条数据(有可能是nil ，点赞模型，评论模型)
        if (self.moment.attitudesList.count>0) {
            /// 有数据
            MHMomentAttitudesViewModel * attitudes = self.operationMores.firstObject;
            if ([attitudes isKindOfClass:[MHMomentAttitudesViewModel class]]) {
                /// 修改数据 （移除/拼接）
                [attitudes.operationCmd execute:self.moment];
            }else{
                /// 插入数据到 index = 0 （创建数据）
                MHMomentAttitudesViewModel *atti = [[MHMomentAttitudesViewModel alloc] initWithMoment:self.moment];
                NSMutableArray *ops = [NSMutableArray array];
                if (self.operationMores) {
                    [ops addObject:atti];
                    [ops addObjectsFromArray:self.operationMores];
                    self.operationMores = ops.copy;
                    
                }else{
                    self.operationMores = @[atti];
                }
            }
        }else{
            self.operationMores = nil;
        }
        /// 更新布局 向上的箭头
        [self _updateUpArrowViewFrameForOperationMoreChanged];
        /// 回调到视图控制器，刷新表格的section，这里特别注意的是：微信这里不论有网，没网，你点赞Or取消点赞都是可以操作的，所以以上都是前端处理
        [self.reloadSectionSubject sendNext:input];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            /// 这里发起请求 (无非不是把moment的attitudesStatus，提交到服务器罢了)
            /// 开启网络菊花
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /// 关闭网络菊花
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            return nil;
        }];
    }];
    /// 开启并行执行
    self.attitudeOperationCmd.allowsConcurrentExecution = YES;
    
    
    /// 用户点击展开全文
    self.expandOperationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * input) {
        @strongify(self);
        self.expand = !self.isExpand;
        /// 更新所有布局
        [self _updateSubviewsFrameWithExpand:self.isExpand];
        /// 回调控制器
        [self.reloadSectionSubject sendNext:input];
        return [RACSignal empty];
    }];
    self.expandOperationCmd.allowsConcurrentExecution = YES;
    
    
    /// 
}













/**
 更新内部控件尺寸模型 （点击全文or收起）
 @param expand 全文/收起
 */
- (void)_updateSubviewsFrameWithExpand:(BOOL)expand{
    self.expand = expand;
    
    CGFloat limitWidth = MHMomentCommentViewWidth();
    
    /// 正文
    CGFloat contentLableX = self.screenNameLableFrame.origin.x;
    /// -4 修正间距
    CGFloat contentLableY = CGRectGetMaxY(self.screenNameLableFrame)+MHMomentContentInnerMargin-4;
    /// 需要计算正文的size default 正文为空
    CGSize contentLableSize = CGSizeZero;
    
    /// 全文/收起按钮
    CGFloat expandBtnX = contentLableX;
    /// 这里事先设置
    CGFloat expandBtnY = contentLableY;
    CGFloat expandBtnW = MHMomentExpandButtonWidth;
    CGFloat expandBtnH = 0;
    
    /// 这里要分情况
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(limitWidth, MAXFLOAT)];
    YYTextLayout *layout = nil;
    if (MHStringIsNotEmpty(self.moment.text)) {
        
        /// 显示部分正文 （按钮显示 `全文`）(默认是全部显示)
        contentLableSize = self.contentLableLayout.textBoundingSize;
        
        /// 计算尺寸
        /// 首先判断是否大于正文显示行数的是否超过最大允许的最大行数值
        /// PS： 目前还没有做
        if (self.contentLableLayout.rowCount > MHMomentContentTextMaxCriticalRow) {
            /// 容错
            self.expand = NO;
            /// 就显示单行
            container.maximumNumberOfRows = 1;
            layout = [YYTextLayout layoutWithContainer:container text:self.contentLableLayout.text];
            /// 全文/收起 高度为0
            expandBtnH = .0f;
        }else if(self.contentLableLayout.rowCount > MHMomentContentTextExpandCriticalRow){
            /// 重新计算
            if(!expand){
                /// 点击收起 -- 显示全文
                container.maximumNumberOfRows = MHMomentContentTextExpandCriticalRow;
                layout = [YYTextLayout layoutWithContainer:container text:self.contentLableLayout.text];
                contentLableSize = layout.textBoundingSize;
            }
            /// 全文/收起 高度
            expandBtnH = MHMomentExpandButtonHeight;
        }
        
        /// 全文/收起Y
        expandBtnY = contentLableY + contentLableSize.height +MHMomentContentInnerMargin;
    }

    /// 正文
    self.contentLableFrame = CGRectMake(contentLableX, contentLableY, contentLableSize.width, contentLableSize.height);
    
    /// 全文/收起
    self.expandBtnFrame = CGRectMake(expandBtnX, expandBtnY, expandBtnW, expandBtnH);
    
    /// pictureView
    CGFloat pictureViewX = contentLableX;
    CGFloat pictureViewTopMargin = (expandBtnH>0)?MHMomentContentInnerMargin:0;
    CGFloat pictureViewY = CGRectGetMaxY(self.expandBtnFrame)+pictureViewTopMargin;
    CGSize pictureViewSize = [self _pictureViewSizeWithPhotosCount:self.moment.picInfos.count];
    self.photosViewFrame = (CGRect){{pictureViewX , pictureViewY},pictureViewSize};
    
    /// 地理位置
    CGFloat locationLableX = contentLableX;
    /// 顶部
    CGFloat locationLabelTopMargin = (pictureViewSize.height>0)?MHMomentContentInnerMargin:0;
    CGFloat locationLableY = CGRectGetMaxY(self.photosViewFrame)+locationLabelTopMargin;
    self.locationLableFrame = CGRectMake(locationLableX, locationLableY, self.locationLableLayout.textBoundingSize.width, self.locationLableLayout.textBoundingSize.height);
    
    
    /// 更多按钮
    CGFloat operationMoreBtnX = MH_SCREEN_WIDTH - MHMomentContentLeftOrRightInset - MHMomentOperationMoreBtnWH +(MHMomentOperationMoreBtnWH - 25)*.5f;
    CGFloat operationMoreBtnTopMargin = (self.locationLableFrame.size.height>0)?(MHMomentContentInnerMargin-5):0;
    CGFloat operationMoreBtnY = CGRectGetMaxY(self.locationLableFrame)+operationMoreBtnTopMargin;
    CGFloat operationMoreBtnW = MHMomentOperationMoreBtnWH;
    CGFloat operationMoreBtnH = MHMomentOperationMoreBtnWH;
    self.operationMoreBtnFrame = CGRectMake(operationMoreBtnX, operationMoreBtnY, operationMoreBtnW, operationMoreBtnH);

    /// 评论or点赞 向上箭头 (由于评论Or点赞成功 headerView高度都会变化 ，故需要抽出去)
    [self _updateUpArrowViewFrameForOperationMoreChanged];
}


/// 由于更多按钮的事件生效（PS：点赞成功/失败 Or 评论成功/失败）都会导致headerView的高度changeed
- (void)_updateUpArrowViewFrameForOperationMoreChanged
{
    BOOL isAllowShowUpArrowView = (self.moment.commentsList.count>0||self.moment.attitudesList.count>0);
    CGFloat upArrowViewX = self.screenNameLableFrame.origin.x;
    /// -5是为了适配
    CGFloat upArrowViewTopMargin = isAllowShowUpArrowView?(MHMomentContentInnerMargin-5):0;
    CGFloat upArrowViewY = CGRectGetMaxY(self.operationMoreBtnFrame)+upArrowViewTopMargin;
    CGFloat upArrowViewW = MHMomentUpArrowViewWidth;
    CGFloat upArrowViewH = isAllowShowUpArrowView?MHMomentUpArrowViewHeight:0;
    self.upArrowViewFrame = CGRectMake(upArrowViewX, upArrowViewY, upArrowViewW, upArrowViewH);
    
    /// 整个header的高度
    self.height = CGRectGetMaxY(self.upArrowViewFrame);
}



#pragma mark - Getter & Setter
/// 滚动过程 时间会一直改变 所以是Getter方法 并且（其尺寸和来源的尺寸也得随着时间的变化而变化）
- (CGRect)createAtLableFrame{
    /// 时间
    CGFloat createAtLableX = self.screenNameLableFrame.origin.x;
    CGFloat createAtLableY = self.operationMoreBtnFrame.origin.y;
    return (CGRect){{createAtLableX , createAtLableY},{self.createAtLableLayout.textBoundingSize.width , self.operationMoreBtnFrame.size.height}};
}
- (YYTextLayout *)createAtLableLayout{
    if (!self.createdAt) return nil;
    /// 布局
    YYTextLayout *createAtLableLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, MAXFLOAT) text:self.createdAt];
    return createAtLableLayout;
}

- (CGRect)sourceLableFrame{
    if (!MHStringIsNotEmpty(self.moment.source)) return CGRectZero;
    CGFloat sourceLableX = CGRectGetMaxX(self.createAtLableFrame)+MHMomentContentInnerMargin;
    CGFloat sourceLableY = self.operationMoreBtnFrame.origin.y;
    CGSize sourceLableSize = self.sourceLableLayout.textBoundingSize;
    return (CGRect){{sourceLableX , sourceLableY},{sourceLableSize.width , self.operationMoreBtnFrame.size.height}};
}

#pragma mark - 辅助方法
/// 创建时间
- (NSAttributedString *)createdAt{
    /// 滚动过程 时间会一直改变 所以是Getter 并且（尺寸和来源的尺寸也得随着变化）
    NSString *timeStr =  [MHMomentHelper createdAtTimeWithSourceDate:self.moment.createdAt];
    if (!MHStringIsNotEmpty(timeStr)) return nil;
    NSMutableAttributedString *createdAtAttr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    createdAtAttr.yy_font = MHMomentCreatedAtFont;
    createdAtAttr.yy_color = MHMomentCreatedAtTextColor;
    return createdAtAttr.copy;
}
/// pictureView的整体size
- (CGSize)_pictureViewSizeWithPhotosCount:(NSUInteger)photosCount{
    // 0张图 CGSizeZero
    if (photosCount==0) return CGSizeZero;
    
    /// 考虑屏幕尺寸为 320的情况
    CGFloat pictureViewItemWH = MHMomentPhotosViewItemWidth();
    
    /// 这里需要考虑一张图片等比显示的情况
    if(photosCount==1){
        CGSize picSize = CGSizeZero;
        CGFloat maxWidth = MHMomentPhotosViewSingleItemMaxWidth();
        CGFloat maxHeight = MHMomentPhotosViewSingleItemMaxHeight;
        
        MHPicture *pic = self.moment.picInfos.firstObject;
        MHPictureMetadata *bmiddle = pic.bmiddle;
        
        if (pic.keepSize || bmiddle.width < 1 || bmiddle.height < 1) {
            /// 固定方形
            picSize = CGSizeMake(maxWidth, maxWidth);
        } else {
            /// 等比显示
            if (bmiddle.width < bmiddle.height) {
                picSize.width = (float)bmiddle.width / (float)bmiddle.height * maxHeight;
                picSize.height = maxHeight;
            } else {
                picSize.width = maxWidth;
                picSize.height = (float)bmiddle.height / (float)bmiddle.width * maxWidth;
            }
        }
        return picSize;
    }
    
    
    /// 大于1的情况 统统显示 九宫格样式
    NSUInteger maxCols = MHMomentMaxCols(photosCount);
    
    // 总列数
    NSUInteger totalCols = photosCount >= maxCols ?  maxCols : photosCount;
    
    // 总行数
    NSUInteger totalRows = (photosCount + maxCols - 1) / maxCols;
    
    // 计算尺寸
    CGFloat photosW = totalCols * pictureViewItemWH + (totalCols - 1) * MHMomentPhotosViewItemInnerMargin;
    CGFloat photosH = totalRows * pictureViewItemWH + (totalRows - 1) * MHMomentPhotosViewItemInnerMargin;
    return CGSizeMake(photosW, photosH);
}

@end
