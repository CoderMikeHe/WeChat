//
//  LCActionSheetCell.h
//  LCActionSheet
//
//  Created by Leo on 2016/7/15.
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


#import <UIKit/UIKit.h>


#define LC_ACTION_SHEET_CELL_NO_HIDDE_LINE_TAG  100
#define LC_ACTION_SHEET_CELL_HIDDE_LINE_TAG     101

NS_ASSUME_NONNULL_BEGIN

@interface LCActionSheetCell : UITableViewCell

/**
 Title label.
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 Line.
 */
@property (nonatomic, weak) UIView *lineView;

/**
 Cell's separator color.
 */
@property (nonatomic, strong) UIColor *cellSeparatorColor;

@end

NS_ASSUME_NONNULL_END
