//
//  MHSearchTypeViewController.m
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchTypeViewController.h"

@interface MHSearchTypeViewController ()<UIGestureRecognizerDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHSearchTypeViewModel *viewModel;
@end

@implementation MHSearchTypeViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 添加一个边缘手势
    UIScreenEdgePanGestureRecognizer *panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureDetected:)];
    panGestureRecognizer.edges = UIRectEdgeLeft;
    [panGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 辅助方法
-(void)_panGestureDetected:(UIScreenEdgePanGestureRecognizer *)recognizer{

    /*获取状态*/
    UIGestureRecognizerState state = [recognizer state];
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        /*获取拖动的位置*/
        CGPoint translation = [recognizer translationInView:recognizer.view];
        /*每次都以传入的translation为起始参照*/
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, 0)];
        /*设置当前拖动的位置*/
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        if (recognizer.view.mh_left <= recognizer.view.mh_width * 0.5) {
            // 归位
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [recognizer.view setTransform:CGAffineTransformIdentity];
            } completion:^(BOOL finished) {
            }];
        }else {
            // 返回
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [recognizer.view setTransform:CGAffineTransformMakeTranslation(recognizer.view.mh_width, 0)];
            } completion:^(BOOL finished) {
                /// 回调回去
                [self.viewModel.popSubject sendNext:@1];
            }];
        }
        
    }
}

#pragma mark - UIGestureRecognizerDelegate
// 是否允许pan
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
