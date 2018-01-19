//
//  MHMenuController.m
//  WeChat
//
//  Created by senba on 2018/1/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHMenuController.h"
#import "MHMomentOperationMoreView.h"

@interface MHMenuController ()

/// targert
@property (nonatomic, readwrite, assign) CGRect targetRect;

/// targetView
@property (nonatomic, readwrite, weak) UIView *targetView;

/// moreView
@property (nonatomic, readwrite, strong) MHMomentOperationMoreView *moreView;

@end


@implementation MHMenuController

static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedMenuController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone{
    return _instace;
}


- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated{
    _menuVisible = menuVisible;
    
    if (menuVisible) { /// 显示
        [self.targetView.superview addSubview:self.moreView];
        self.moreView.frame = CGRectMake(self.targetView.frame.origin.x, self.targetView.frame.origin.y, 0, MHMomentOperationMoreViewHeight);
        self.moreView.mh_centerY = self.targetView.mh_centerY;
        [UIView animateWithDuration:.1 animations:^{
            [self.moreView setFrame:CGRectMake(self.targetView.frame.origin.x - MHMomentOperationMoreViewWidth - MHMomentContentInnerMargin, self.targetView.frame.origin.y, MHMomentOperationMoreViewWidth, MHMomentOperationMoreViewHeight)];
            self.moreView.mh_centerY = self.targetView.mh_centerY;
        }];
        
    }else{
        [UIView animateWithDuration:.1 animations:^{
            [self.moreView setFrame:CGRectMake(self.targetView.frame.origin.x - MHMomentContentInnerMargin , self.targetView.frame.origin.y, 0, MHMomentOperationMoreViewHeight)];
            self.moreView.mh_centerY = self.targetView.mh_centerY;
        }];
    }
}



- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView{
    /*
     targetRect：menuController指向的矩形框
     targetView：targetRect以targetView的左上角为坐标原点
     */
    self.targetRect = targetRect;
    self.targetView = targetView;
    
    ///
    
}


- (void)setMenuItems:(NSArray<MHMenuItem *> *)menuItems{
    _menuItems = menuItems;
    
    /// 
}


- (MHMomentOperationMoreView *)moreView{
    if (_moreView == nil) {
        _moreView = [[MHMomentOperationMoreView alloc] init];
    }
    return _moreView;
}
@end
