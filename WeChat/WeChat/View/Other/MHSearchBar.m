//
//  MHSearchBar.m
//  WeChat
//
//  Created by senba on 2017/9/28.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSearchBar.h"

@implementation MHSearchBar
+ (void)initialize{
    [super initialize];
    
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.placeholder = @"搜索";
    self.barStyle = UIBarStyleDefault;
    self.barTintColor = MH_MAIN_BACKGROUNDCOLOR;
    self.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
    UIImageView *view = [[[self.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = MHColorFromHexString(@"#DFDFDD").CGColor;
    view.layer.borderWidth = 1;
    self.backgroundImage = MHImageNamed(@"widget_searchbar_cell_bg_5x44");
    [self setSearchFieldBackgroundImage:MHImageNamed(@"widget_searchbar_textfield_17x28") forState:UIControlStateNormal];
    self.searchBarStyle = UISearchBarStyleProminent;
    [self sizeToFit];
}

@end
