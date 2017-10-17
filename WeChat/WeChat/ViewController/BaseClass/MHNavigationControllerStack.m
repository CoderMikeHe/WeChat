//
//  MHNavigationControllerStack.m
//  WeChat
//
//  Created by senba on 2017/9/5.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHNavigationControllerStack.h"
#import "MHNavigationController.h"
#import "MHTabBarController.h"
#import "MHRouter.h"

@interface MHNavigationControllerStack ()

@property (nonatomic, strong) id<MHViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation MHNavigationControllerStack

- (instancetype)initWithServices:(id<MHViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.navigationControllers = [[NSMutableArray alloc] init];
        [self registerNavigationHooks];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    
    if ([self.navigationControllers containsObject:navigationController]) return;
    
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks {
    @weakify(self)
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         MHViewController *topViewController = (MHViewController *)[self.navigationControllers.lastObject topViewController];
         if (topViewController.tabBarController) {
             topViewController.snapshot = [topViewController.tabBarController.view snapshotViewAfterScreenUpdates:NO];
         } else {
             topViewController.snapshot = [[self.navigationControllers.lastObject view] snapshotViewAfterScreenUpdates:NO];
         }
         UIViewController *viewController = (UIViewController *)[MHRouter.sharedInstance viewControllerForViewModel:tuple.first];
         [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         UIViewController *viewController = (UIViewController *)[MHRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[MHNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
         
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers removeAllObjects];
         /// VM映射VC
         UIViewController *viewController = (UIViewController *)[MHRouter.sharedInstance viewControllerForViewModel:tuple.first];
         if (![viewController isKindOfClass:[UINavigationController class]] &&
             ![viewController isKindOfClass:[MHTabBarController class]]) {
             viewController = [[MHNavigationController alloc] initWithRootViewController:viewController];
             [self pushNavigationController:(UINavigationController *)viewController];
         }
         MHSharedAppDelegate.window.rootViewController = viewController;
     }];
}


@end
