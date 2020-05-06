//
//  MHSearchTypeView.m
//  WeChat
//
//  Created by 何千元 on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchTypeView.h"

@interface MHSearchTypeView ()



@end

@implementation MHSearchTypeView

+ (instancetype)searchTypeView {
    return [self mh_viewFromXib];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 事件处理

- (IBAction)_btnDidClicked:(UIButton *)sender {

    NSLog(@"xxxxxxxxxxxxxxxxx %d", sender.tag);
}


#pragma mark - 辅助方法
@end
