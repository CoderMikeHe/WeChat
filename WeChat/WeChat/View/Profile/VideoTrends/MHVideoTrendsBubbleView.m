//
//  MHVideoTrendsBubbleView.m
//  WeChat
//
//  Created by 何千元 on 2020/8/5.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHVideoTrendsBubbleView.h"

@implementation MHVideoTrendsBubbleView

+ (instancetype)bubbleView {
    return [self mh_viewFromXib];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

@end
