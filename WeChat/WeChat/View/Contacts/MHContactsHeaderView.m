//
//  MHContactsHeaderView.m
//  WeChat
//
//  Created by 何千元 on 2020/4/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHContactsHeaderView.h"

@interface MHContactsHeaderView ()

/// 字符
@property (weak, nonatomic) IBOutlet UILabel *letterLabel;
/// topDivider
@property (weak, nonatomic) IBOutlet UIView *topDivider;
/// bottomDivider
@property (weak, nonatomic) IBOutlet UIView *bottomDivider;


/// viewModel
@property (nonatomic, readwrite, copy) NSString *viewModel;

@end

@implementation MHContactsHeaderView

#pragma mark - Public Method

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ContactsHeader";
    MHContactsHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [self mh_viewFromXib];
    }
    return header;
}

- (void)bindViewModel:(NSString *)viewModel {
    self.viewModel = viewModel;
    
    if ([viewModel isEqualToString:UITableViewIndexSearch]) {
        self.letterLabel.text = nil;
        self.topDivider.hidden = self.bottomDivider.hidden = YES;
    } else {
        self.letterLabel.text = viewModel;
        self.topDivider.hidden = self.bottomDivider.hidden = NO;
    }
}

- (void)configColorWithProgress:(double)progress {
    static NSMutableArray<NSNumber *> *textColorDiffArray;
    static NSMutableArray<NSNumber *> *bgColorDiffArray;
    static NSArray<NSNumber *> *selectTextColorArray;
    static NSArray<NSNumber *> *selectBgColorArray;
    
    if (textColorDiffArray.count == 0) {
        UIColor *selectTextColor = MHColorAlpha(87, 190, 106, 1);
        UIColor *textColor = MHColorAlpha(59, 60, 60, 1);
        // 悬浮背景色
        UIColor *selectBgColor = [UIColor whiteColor];
        // 默认背景色
        UIColor *bgColor = MHColorAlpha(237, 237, 237, 1);
        
        selectTextColorArray = [self getRGBArrayByColor:selectTextColor];
        NSArray<NSNumber *> *textColorArray = [self getRGBArrayByColor:textColor];
        selectBgColorArray = [self getRGBArrayByColor:selectBgColor];
        NSArray<NSNumber *> *bgColorArray = [self getRGBArrayByColor:bgColor];
        
        textColorDiffArray = @[].mutableCopy;
        bgColorDiffArray = @[].mutableCopy;
        for (int i = 0; i < 3; i++) {
            double textDiff = selectTextColorArray[i].doubleValue - textColorArray[i].doubleValue;
            [textColorDiffArray addObject:@(textDiff)];
            double bgDiff = selectBgColorArray[i].doubleValue - bgColorArray[i].doubleValue;
            [bgColorDiffArray addObject:@(bgDiff)];
        }
    }
    
    NSMutableArray<NSNumber *> *textColorNowArray = @[].mutableCopy;
    NSMutableArray<NSNumber *> *bgColorNowArray = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        double textNow = selectTextColorArray[i].doubleValue - progress * textColorDiffArray[i].doubleValue;
        [textColorNowArray addObject:@(textNow)];
        
        double bgNow = selectBgColorArray[i].doubleValue - progress * bgColorDiffArray[i].doubleValue;
        [bgColorNowArray addObject:@(bgNow)];
    }
    
    UIColor *textColor = [self getColorWithRGBArray:textColorNowArray];
    self.letterLabel.textColor = textColor;
    UIColor *bgColor = [self getColorWithRGBArray:bgColorNowArray];
    self.contentView.backgroundColor = bgColor;
}

- (NSArray<NSNumber *> *)getRGBArrayByColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    double components[3];
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
    double r = components[0];
    double g = components[1];
    double b = components[2];
    return @[@(r),@(g),@(b)];
}

- (UIColor *)getColorWithRGBArray:(NSArray<NSNumber *> *)array {
    return [UIColor colorWithRed:array[0].doubleValue green:array[1].doubleValue blue:array[2].doubleValue alpha:1];
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
}

@end
