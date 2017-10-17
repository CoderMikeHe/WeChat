//
//  LCActionSheetConfig.m
//  LCActionSheet
//
//  Created by Leo on 2016/11/29.
//
//  Copyright (c) 2015-2017 Leo <leodaxia@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "LCActionSheetConfig.h"


#define LC_ACTION_SHEET_BUTTON_HEIGHT       49.0f

#define LC_ACTION_SHEET_RED_COLOR           LC_ACTION_SHEET_COLOR(254, 67, 37)

#define LC_ACTION_SHEET_TITLE_FONT          [UIFont systemFontOfSize:14.0f]

#define LC_ACTION_SHEET_BUTTON_FONT         [UIFont systemFontOfSize:18.0f]

#define LC_ACTION_SHEET_ANIMATION_DURATION  0.3f

#define LC_ACTION_SHEET_DARK_OPACITY        0.3f


@implementation LCActionSheetConfig

+ (LCActionSheetConfig *)config {
    static id _config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[self alloc] initSharedInstance];
    });
    return _config;
}

+ (instancetype)shared {
    return self.config;
}

- (instancetype)initSharedInstance {
    if (self = [super init]) {
        self.titleFont              = LC_ACTION_SHEET_TITLE_FONT;
        self.buttonFont             = LC_ACTION_SHEET_BUTTON_FONT;
        self.destructiveButtonColor = LC_ACTION_SHEET_RED_COLOR;
        self.titleColor             = LC_ACTION_SHEET_COLOR(111, 111, 111);
        self.buttonColor            = [UIColor blackColor];

        self.buttonHeight           = LC_ACTION_SHEET_BUTTON_HEIGHT;
        self.animationDuration      = LC_ACTION_SHEET_ANIMATION_DURATION;
        self.darkOpacity            = LC_ACTION_SHEET_DARK_OPACITY;

        self.titleEdgeInsets        = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);

        self.separatorColor         = LC_ACTION_SHEET_COLOR_A(150, 150, 150, 0.3f);
    }
    return self;
}

- (instancetype)init {
    return LCActionSheetConfig.config;
}

- (NSInteger)cancelButtonIndex {
    return 0;
}

@end
