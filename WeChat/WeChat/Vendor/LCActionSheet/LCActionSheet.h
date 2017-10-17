//
//  LCActionSheet.h
//  LCActionSheet
//
//  Created by Leo on 2015/4/27.
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
#import "LCActionSheetConfig.h"


@class LCActionSheet;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - LCActionSheet Block

/**
 Handle click button.
 */
typedef void(^LCActionSheetClickedHandler)(LCActionSheet *actionSheet, NSInteger buttonIndex);

/**
 Handle action sheet will present.
 */
typedef void(^LCActionSheetWillPresentHandler)(LCActionSheet *actionSheet);
/**
 Handle action sheet did present.
 */
typedef void(^LCActionSheetDidPresentHandler)(LCActionSheet *actionSheet);

/**
 Handle action sheet will dismiss.
 */
typedef void(^LCActionSheetWillDismissHandler)(LCActionSheet *actionSheet, NSInteger buttonIndex);
/**
 Handle action sheet did dismiss.
 */
typedef void(^LCActionSheetDidDismissHandler)(LCActionSheet *actionSheet, NSInteger buttonIndex);


#pragma mark - LCActionSheet Delegate

@protocol LCActionSheetDelegate <NSObject>

@optional

/**
 Handle click button.
 */
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

/**
 Handle action sheet will present.
 */
- (void)willPresentActionSheet:(LCActionSheet *)actionSheet;
/**
 Handle action sheet did present.
 */
- (void)didPresentActionSheet:(LCActionSheet *)actionSheet;

/**
 Handle action sheet will dismiss.
 */
- (void)actionSheet:(LCActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
/**
 Handle action sheet did dismiss.
 */
- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end


#pragma mark - LCActionSheet

@interface LCActionSheet : UIView


#pragma mark - Properties

/**
 Title.
 */
@property (nullable, nonatomic, copy) NSString *title;

/**
 Cancel button's title.
 */
@property (nullable, nonatomic, copy) NSString *cancelButtonTitle;

/**
 Cancel button's index.
 */
@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex;

/**
 LCActionSheet's delegate.
 */
@property (nullable, nonatomic, weak) id<LCActionSheetDelegate> delegate;

/**
 Deprecated, use `destructiveButtonIndexSet` instead.
 */
@property (nullable, nonatomic, strong) NSIndexSet *redButtonIndexSet __deprecated_msg("Property deprecated. Use `destructiveButtonIndexSet` instead.");

/**
 All destructive buttons' set. You should give it the `NSNumber` type items.
 */
@property (nullable, nonatomic, strong) NSIndexSet *destructiveButtonIndexSet;

/**
 Destructive button's color. Default is RGB(254, 67, 37).
 */
@property (nonatomic, strong) UIColor *destructiveButtonColor;

/**
 Title's color. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 Buttons' color, without destructive buttons. Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *buttonColor;
/**
 Title's font. Default is `[UIFont systemFontOfSize:14.0f]`.
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 All buttons' font. Default is `[UIFont systemFontOfSize:18.0f]`.
 */
@property (nonatomic, strong) UIFont *buttonFont;
/**
 All buttons' height. Default is 49.0f;
 */
@property (nonatomic, assign) CGFloat buttonHeight;

/**
 If buttons' bottom view can scrolling. Default is NO.
 */
@property (nonatomic, assign, getter=canScrolling) BOOL scrolling;

/**
 Visible buttons' count. You have to set `scrolling = YES` if you want to set it.
 */
@property (nonatomic, assign) CGFloat visibleButtonCount;

/**
 Animation duration. Default is 0.3 seconds.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Opacity of dark background. Default is 0.3f.
 */
@property (nonatomic, assign) CGFloat darkOpacity;

/**
 If you can tap darkView to dismiss. Defalut is NO, you can tap dardView to dismiss.
 */
@property (nonatomic, assign) BOOL darkViewNoTaped;

/**
 Clear blur effect. Default is NO, don't clear blur effect.
 */
@property (nonatomic, assign) BOOL unBlur;

/**
 Style of blur effect. Default is `UIBlurEffectStyleExtraLight`. iOS 8.0 +
 */
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

/**
 Title's edge insets. Default is `UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f)`.
 */
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

/**
 Cell's separator color. Default is `RGBA(170/255.0f, 170/255.0f, 170/255.0f, 0.5f)`.
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 Auto hide when the device rotated. Default is NO, won't auto hide.
 */
@property (nonatomic, assign) BOOL autoHideWhenDeviceRotated;


/**
 LCActionSheet clicked handler.
 */
@property (nullable, nonatomic, copy) LCActionSheetClickedHandler     clickedHandler;
/**
 LCActionSheet will present handler.
 */
@property (nullable, nonatomic, copy) LCActionSheetWillPresentHandler willPresentHandler;
/**
 LCActionSheet did present handler.
 */
@property (nullable, nonatomic, copy) LCActionSheetDidPresentHandler  didPresentHandler;
/**
 LCActionSheet will dismiss handler.
 */
@property (nullable, nonatomic, copy) LCActionSheetWillDismissHandler willDismissHandler;
/**
 LCActionSheet did dismiss handler.
 */
@property (nullable, nonatomic, copy) LCActionSheetDidDismissHandler  didDismissHandler;


#pragma mark - Methods

#pragma mark Delegate

/**
 Initialize an instance of LCActionSheet (Delegate).

 @param title             title
 @param delegate          delegate
 @param cancelButtonTitle cancelButtonTitle
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
                      delegate:(nullable id<LCActionSheetDelegate>)delegate
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
             otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Delegate).

 @param title                 title
 @param delegate              delegate
 @param cancelButtonTitle     cancelButtonTitle
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
                      delegate:(nullable id<LCActionSheetDelegate>)delegate
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
         otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;

/**
 Initialize an instance of LCActionSheet (Delegate).

 @param title             title
 @param delegate          delegate
 @param cancelButtonTitle cancelButtonTitle
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                     delegate:(nullable id<LCActionSheetDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Delegate).

 @param title                 title
 @param delegate              delegate
 @param cancelButtonTitle     cancelButtonTitle
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                     delegate:(nullable id<LCActionSheetDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
        otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;


#pragma mark Block

/**
 Initialize an instance of LCActionSheet (Block).

 @param title             title
 @param cancelButtonTitle cancelButtonTitle
 @param clickedHandler    clickedHandler
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                       clicked:(nullable LCActionSheetClickedHandler)clickedHandler
             otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Block).

 @param title                 title
 @param cancelButtonTitle     cancelButtonTitle
 @param clickedHandler        clickedHandler
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                       clicked:(nullable LCActionSheetClickedHandler)clickedHandler
         otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;

/**
 Initialize an instance of LCActionSheet (Block).

 @param title             title
 @param cancelButtonTitle cancelButtonTitle
 @param clickedHandler    clickedHandler
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      clicked:(nullable LCActionSheetClickedHandler)clickedHandler
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Block).

 @param title                 title
 @param cancelButtonTitle     cancelButtonTitle
 @param clickedHandler        clickedHandler
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      clicked:(nullable LCActionSheetClickedHandler)clickedHandler
        otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;



/**
 Initialize an instance of LCActionSheet (Block).
 
 @param title             title
 @param cancelButtonTitle cancelButtonTitle
 @param didDismissHandler didDismissHandler
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    didDismiss:(nullable LCActionSheetDidDismissHandler)didDismissHandler
             otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Block).
 
 @param title                 title
 @param cancelButtonTitle     cancelButtonTitle
 @param didDismissHandler     didDismissHandler
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
+ (instancetype)sheetWithTitle:(nullable NSString *)title
             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    didDismiss:(nullable LCActionSheetDidDismissHandler)didDismissHandler
         otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;

/**
 Initialize an instance of LCActionSheet (Block).
 
 @param title             title
 @param cancelButtonTitle cancelButtonTitle
 @param didDismissHandler didDismissHandler
 @param otherButtonTitles otherButtonTitles
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                   didDismiss:(nullable LCActionSheetDidDismissHandler)didDismissHandler
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initialize an instance of LCActionSheet with title array (Block).
 
 @param title                 title
 @param cancelButtonTitle     cancelButtonTitle
 @param didDismissHandler     didDismissHandler
 @param otherButtonTitleArray otherButtonTitleArray
 
 @return An instance of LCActionSheet.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                   didDismiss:(nullable LCActionSheetDidDismissHandler)didDismissHandler
        otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray;


#pragma mark Append & Show

/**
 Append buttons with titles.

 @param titles titles
 */
- (void)appendButtonsWithTitles:(nullable NSString *)titles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Append button at index with title.

 @param title title
 @param index index
 */
- (void)appendButtonWithTitle:(nullable NSString *)title atIndex:(NSInteger)index;

/**
 Append buttons at indexSet with titles.

 @param titles  titles
 @param indexes indexes
 */
- (void)appendButtonsWithTitles:(NSArray<NSString *> *)titles atIndexes:(NSIndexSet *)indexes;

/**
 Show the instance of LCActionSheet.
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END

