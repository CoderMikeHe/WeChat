//
//  MHSegmentedControlController.h
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewController.h"

@class MHSegmentedControlController;

@protocol MHSegmentedControlControllerDelegate <NSObject>

@optional

- (void)segmentedControlController:(MHSegmentedControlController *)segmentedControlController didSelectViewController:(UIViewController *)viewController;

@end

@interface MHSegmentedControlController : MHViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) id<MHSegmentedControlControllerDelegate> delegate;

@end

@interface UIViewController (MHSegmentedControlItem)

@property (nonatomic, copy) NSString *segmentedControlItem;

@end

