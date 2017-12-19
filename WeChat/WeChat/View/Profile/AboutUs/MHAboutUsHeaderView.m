//
//  MHAboutUsHeaderView.m
//  WeChat
//
//  Created by senba on 2017/12/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAboutUsHeaderView.h"

@interface MHAboutUsHeaderView ()
/// versionLabel
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end


@implementation MHAboutUsHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 版本
    self.versionLabel.text = [NSString stringWithFormat:@"微信 WeChat %@" , MH_APP_VERSION];
    
}

@end
