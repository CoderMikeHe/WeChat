//
//  MHTableView.m
//  WeChat
//
//  Created by senba on 2017/12/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableView.h"
#import "MHMomentOperationMoreView.h"
@implementation MHTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MHMomentOperationMoreView hideAllOperationMoreViewWithAnimated:YES];
    [super touchesBegan:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * hitView = [super hitTest:point withEvent:event];
    return hitView;
}
@end
