//
//  MHSearchRelatedView.m
//  WeChat
//
//  Created by 何千元 on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchRelatedView.h"

@implementation MHSearchRelatedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 1.获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGFloat lineWidth = 1.3f;
    
    // 2. 绘制三角形
    // 设置起点
    CGContextMoveToPoint(ctx, lineWidth * .5f, 0);
    // 添加第一条线
    CGContextAddLineToPoint(ctx, lineWidth * .5f, rect.size.height);
    // 设置线条的宽度
    CGContextSetLineWidth(ctx, lineWidth);
    // 设置线条的颜色
    [MHColorFromHexString(@"#b3b3b3") set];

    // 设置线条两端的样式为圆直角
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    
    
    // 设置起点
    CGContextMoveToPoint(ctx, lineWidth * .5f, lineWidth * .5f);
    // 添加第二条线
    CGContextAddLineToPoint(ctx, rect.size.width, lineWidth * .5f);

    // 设置起点
    CGContextMoveToPoint(ctx, 0, 0);
    // 添加第3条线
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);

    // 3.渲染图形到layer上
    CGContextStrokePath(ctx);
}


@end
