//
//  MHTableView.m
//  WeChat
//
//  Created by senba on 2017/12/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableView.h"

@implementation MHTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /// 处理popView
    [MHMomentHelper hideAllPopViewWithAnimated:YES];
    
    /// 全局
    [super touchesBegan:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * hitView = [super hitTest:point withEvent:event];
    return hitView;
}
@end
