//
//  MHGroupAvatarsViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHGroupAvatarsViewModel.h"


@interface MHGroupAvatarsViewModel ()

/// users 群聊用户
@property (nonatomic, readwrite, copy) NSArray *users;
/// 盒模型尺寸
@property (nonatomic, readwrite, assign) CGSize targetSize;
/// 每个用户之间的间距和距离盒模型边缘的距离
@property (nonatomic, readwrite, assign) CGFloat innerSpace;
/// itemViewModels
@property (nonatomic, readwrite, copy) NSArray *itemViewModels;
@end


@implementation MHGroupAvatarsViewModel

- (instancetype)initWithUsers:(NSArray *)users targetSize:(CGSize)targetSize innerSpace:(CGFloat)innerSpace
{
    self = [super init];
    if (self) {
        self.users = users;
        self.targetSize = targetSize;
        self.innerSpace = innerSpace;
        
        NSMutableArray *itemViewModels = [NSMutableArray array];
        
        CGFloat width = targetSize.width;
        CGFloat height = targetSize.height;
        
        CGFloat centerX = width * .5f;
        CGFloat centerY = height * .5f;
        
        // 计算 user 的宽高 3 x 3
        NSInteger row = 3;
        NSInteger column = 3;
        CGFloat w = (width - (column + 1.0) * innerSpace)/ column;
        CGFloat h = (height - (row + 1.0) * innerSpace)/ row;
        
        
        NSUInteger count = users.count;
        /// 计算尺寸
        for (NSInteger i = 0; i < count; i++) {
            MHUser *user = users[i];
            switch (count) {
                case 3:
                {
                    w = (width - 3.0 * innerSpace)/2;
                    h = (height - 3.0 * innerSpace)/2;
                    if (i == 0) {
                        CGFloat x = centerX - w * .5f;
                        CGFloat y = innerSpace;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }else {
                        CGFloat x = innerSpace + (innerSpace + w) * (i - 1);
                        CGFloat y = innerSpace + (innerSpace + h);
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }
                }
                    break;
                case 4:
                {
                    w = (width - 3.0 * innerSpace)/2;
                    h = (height - 3.0 * innerSpace)/2;
                    CGFloat x = innerSpace + (innerSpace + w) * (i % 2);
                    CGFloat y = innerSpace + (innerSpace + h) * (i / 2);
                    CGRect frame = CGRectMake(x, y, w, h);
                    MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                    [itemViewModels addObject:itemViewModel];
                }
                    break;
                case 5:
                {
                    if (i == 0 || i == 1) {
                        CGFloat x = i == 0 ? (centerX - innerSpace * .5f - w) : (centerX + innerSpace * .5f) ;
                        CGFloat y = centerY - innerSpace * .5f - h;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else {
                        CGFloat x = (i - 2) * (innerSpace + w) + innerSpace;
                        CGFloat y = centerY + innerSpace * .5f;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }
                }
                    break;
                case 6:
                {
                    if (i == 0 || i == 1 || i == 2) {
                        CGFloat x = i * (innerSpace + w) + innerSpace;
                        CGFloat y = centerY - innerSpace * .5f - h;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else {
                        CGFloat x = (i - 3) * (innerSpace + w) + innerSpace ;
                        CGFloat y = centerY + innerSpace * .5f;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }
                }
                    break;
                case 7:
                {
                    if (i == 0) {
                        CGFloat x = centerX - w * .5f;
                        CGFloat y = innerSpace;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else if (i == 1 || i == 2 || i == 3) {
                        CGFloat x = innerSpace + (innerSpace + w) * (i - 1)  ;
                        CGFloat y = (innerSpace + (innerSpace + h));
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else {
                        CGFloat x = (i - 4) * (innerSpace + w) + innerSpace ;
                        CGFloat y = innerSpace + (innerSpace + h) * 2;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }
                }
                    break;
                case 8:
                {
                    if (i == 0 || i == 1) {
                        CGFloat x = i == 0 ? (centerX - innerSpace * .5f - w) : (centerX + innerSpace * .5f) ;
                        CGFloat y = innerSpace;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else if (i == 2 || i == 3 || i == 4) {
                        CGFloat x = (i - 2) * (innerSpace + w) + innerSpace ;
                        CGFloat y = (innerSpace + (innerSpace + h));
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    } else {
                        CGFloat x = (i - 5) * (innerSpace + w) + innerSpace;
                        CGFloat y = (innerSpace + (innerSpace + h)) * 2;
                        CGRect frame = CGRectMake(x, y, w, h);
                        MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                        [itemViewModels addObject:itemViewModel];
                    }
                }
                    break;
                case 9:
                {
                    CGFloat x = innerSpace + (innerSpace + w) * (i % column);
                    CGFloat y = innerSpace + (innerSpace + h) * (i / row);
                    CGRect frame = CGRectMake(x, y, w, h);
                    MHGroupAvatarsItemViewModel *itemViewModel = [[MHGroupAvatarsItemViewModel alloc] initWithUser:user frame:frame];
                    [itemViewModels addObject:itemViewModel];
                }
                    break;
                default:
                    break;
            }
        }
        
        self.itemViewModels = itemViewModels.copy;
    }
    return self;
}

@end
