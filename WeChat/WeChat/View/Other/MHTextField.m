//
//  MHTextField.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTextField.h"

@implementation MHTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tintColor = MH_MAIN_TINTCOLOR;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tintColor = MH_MAIN_TINTCOLOR;
    }
    return self;
}
@end
