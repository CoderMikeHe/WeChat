
#import <UIKit/UIKit.h>

extern const NSUInteger SCIndexViewInvalidSection;
extern const NSInteger SCIndexViewSearchSection;

typedef NS_ENUM(NSUInteger, SCIndexViewStyle) {
    SCIndexViewStyleDefault = 0,    // 指向点
    SCIndexViewStyleCenterToast,    // 中心提示弹层
};

@interface SCIndexViewConfiguration : NSObject

@property (nonatomic, assign, readonly) SCIndexViewStyle indexViewStyle;    // 索引提示风格

@property (nonatomic, strong) UIColor *indicatorBackgroundColor;            // 指示器背景颜色
@property (nonatomic, strong) UIColor *indicatorTextColor;                  // 指示器文字颜色
@property (nonatomic, strong) UIFont *indicatorTextFont;                    // 指示器文字字体
@property (nonatomic, assign) CGFloat indicatorHeight;                      // 指示器高度
@property (nonatomic, assign) CGFloat indicatorRightMargin;                 // 指示器距离右边屏幕距离（default有效）
@property (nonatomic, assign) CGFloat indicatorCornerRadius;                // 指示器圆角半径（centerToast有效）

@property (nonatomic, strong) UIColor *indexItemBackgroundColor;            // 索引元素背景颜色
@property (nonatomic, strong) UIColor *indexItemTextColor;                  // 索引元素文字颜色
@property (nonatomic, strong) UIColor *indexItemSelectedBackgroundColor;    // 索引元素选中时背景颜色
@property (nonatomic, strong) UIColor *indexItemSelectedTextColor;          // 索引元素选中时文字颜色
@property (nonatomic, assign) CGFloat indexItemHeight;                      // 索引元素高度
@property (nonatomic, assign) CGFloat indexItemRightMargin;                 // 索引元素距离右边屏幕距离
@property (nonatomic, assign) CGFloat indexItemsSpace;                      // 索引元素之间间隔距离

+ (instancetype)configuration;

+ (instancetype)configurationWithIndexViewStyle:(SCIndexViewStyle)indexViewStyle;

@end
