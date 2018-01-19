//
//  MHMenuController.h
//  WeChat
//
//  Created by senba on 2018/1/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  用于微信评论和点赞

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MHMenuItem;

@interface MHMenuController : NSObject

+ (instancetype)sharedMenuController;

@property(nonatomic,getter=isMenuVisible) BOOL menuVisible;        // default is NO

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;

// default is nil. these are in addition to the standard items
@property(nullable, nonatomic,copy) NSArray<MHMenuItem *> *menuItems;

@property(nonatomic , readonly , assign) CGRect menuFrame;

@end


@interface MHMenuItem : NSObject

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;

@property(nonatomic , readwrite , copy) NSString *title;
@property(nonatomic , readwrite , assign)   SEL       action;

@end
