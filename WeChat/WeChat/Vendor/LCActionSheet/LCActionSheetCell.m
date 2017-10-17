//
//  LCActionSheetCell.m
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


#import "LCActionSheetCell.h"
#import "Masonry.h"
#import "LCActionSheetConfig.h"

@interface LCActionSheetCell ()

/**
 *  Highlighted View.
 */
@property (nonatomic, weak) UIView *highlightedView;

@end

@implementation LCActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *highlightedView  = [[UIView alloc] init];
        highlightedView.backgroundColor = self.cellSeparatorColor;
        highlightedView.clipsToBounds   = YES;
        highlightedView.hidden          = YES;
        [self.contentView addSubview:highlightedView];
        self.highlightedView = highlightedView;
        [highlightedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10.0f, 0, 10.0f));
        }];
        
        UIView *lineView  = [[UIView alloc] init];
        lineView.backgroundColor = self.cellSeparatorColor;
        lineView.contentMode   = UIViewContentModeBottom;
        lineView.clipsToBounds = YES;
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5f);
        }];
    }
    return self;
}

- (void)setCellSeparatorColor:(UIColor *)cellSeparatorColor {
    _cellSeparatorColor = cellSeparatorColor;
    
    self.highlightedView.backgroundColor = cellSeparatorColor;
    self.lineView.backgroundColor = cellSeparatorColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.tag == LC_ACTION_SHEET_CELL_HIDDE_LINE_TAG) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = highlighted;
    }
    
    self.highlightedView.hidden = !highlighted;
}

@end
