//
//  WeatherView.m
//  SiShi
//
//  Created by whbalzac on 09/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherView.h"
#import "WHWeatherSunView.h"
#import "WHWeatherClound.h"
#import "WHWeatherRainView.h"
#import "WHWeatherSnowView.h"
#import "WHWeatherHeader.h"

#define kSunDayTopColor UIColorFromRGB(41, 145, 197)
#define kSunDayBottomColor UIColorFromRGB(63, 159, 204)

#define kSunNightTopColor UIColorFromRGB(11, 13, 30)
#define kSunNightDayBottomColor UIColorFromRGB(28, 33, 52)

#define kRainDayTopColor UIColorFromRGB(73, 115, 146)
#define kRainDayBottomColor UIColorFromRGB(61, 96, 123)

#define kRainNightTopColor UIColorFromRGB(13, 13, 18)
#define kRainNightBottomColor UIColorFromRGB(25, 27, 36)

#define kWeatherChangeAnimationDuration 1.0

typedef NS_ENUM(NSInteger, WHWeatherBackViewType){
    WHWeatherBackViewTypeSunDay = 0,
    WHWeatherBackViewTypeSunNight = 1,
    WHWeatherBackViewTypeRainDay = 2,
    WHWeatherBackViewTypeRainNight = 3
};


@interface WHWeatherView ()
@property (nonatomic, strong) WHWeatherBaseView *displayView;
@property (nonatomic, strong) WHWeatherBaseView *willDisplayView;
@property (nonatomic, strong) NSMutableArray *animationArray;
@end

@implementation WHWeatherView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configueWeather];
    }
    return self;
}

- (void)configueWeather
{
    [self showWeatherAnimationWithType:WHWeatherTypeSun];
}

#pragma mark -
#pragma mark - Priavte Method

- (void)showWeatherAnimationWithType:(WHWeatherType)weatherType
{
    [self addOrRemoveAnimationQueueWithType:NO addType:weatherType];
}

- (void)addOrRemoveAnimationQueueWithType:(BOOL)isRemove addType:(WHWeatherType)weatherType
{
    if (self.animationArray) {
        if (isRemove) {
            if (self.animationArray.count > 0) {
                [self.animationArray removeObjectAtIndex:0];
                
                if (self.animationArray.count > 0) {
                    [self startAnimationQueue];
                }
            }
        }else{
            if (self.animationArray.count == 0) {
                [self.animationArray addObject:@(weatherType)];
                [self startAnimationQueue];
            }else{
                [self.animationArray addObject:@(weatherType)];
            }
        }
    }
}

- (void)startAnimationQueue
{
    if (!self.animationArray || !self.animationArray.count) {
        return;
    }
    
    NSNumber *nextAnimationNumber = self.animationArray[0];
    WHWeatherType weatherType = nextAnimationNumber.integerValue;
    
    if (weatherType == WHWeatherTypeSun || weatherType == WHWeatherTypeOther) {

        WHWeatherSunView *sunView = [[WHWeatherSunView alloc] init];
        sunView.frame = self.frame;
        [self addSubview:sunView];
        self.willDisplayView = sunView;
    }else if (weatherType == WHWeatherTypeClound) {
        
        WHWeatherClound *cloundView = [[WHWeatherClound alloc] init];
        cloundView.frame = self.frame;
        [self addSubview:cloundView];
        self.willDisplayView = cloundView;
    }else if (weatherType == WHWeatherTypeRain) {
        
        WHWeatherRainView *rainView = [[WHWeatherRainView alloc] init];
        rainView.isLighting = NO;
        rainView.frame = self.frame;
        [self addSubview:rainView];
        self.willDisplayView = rainView;
    }else if (weatherType == WHWeatherTypeRainLighting) {
        
        WHWeatherRainView *rainView = [[WHWeatherRainView alloc] init];
        rainView.isLighting = YES;
        rainView.frame = self.frame;
        [self addSubview:rainView];
        self.willDisplayView = rainView;
    }else if (weatherType == WHWeatherTypeSnow) {
        
        WHWeatherSnowView *snowView = [[WHWeatherSnowView alloc] init];
        snowView.frame = self.frame;
        [self addSubview:snowView];
        self.willDisplayView = snowView;
    }
    
    WHWeatherBackViewType weatherBackViewType = [self getWeatherBackViewType:nextAnimationNumber.integerValue];
    UIImage *backImage;
    if (weatherBackViewType == WHWeatherBackViewTypeSunDay) {
        backImage = [self getGradientImage:kSunDayTopColor and:kSunDayBottomColor];
    }else if (weatherBackViewType == WHWeatherBackViewTypeSunNight) {
        backImage = [self getGradientImage:kSunNightTopColor and:kSunNightDayBottomColor];
    }else if (weatherBackViewType == WHWeatherBackViewTypeRainDay) {
        backImage = [self getGradientImage:kRainDayTopColor and:kRainDayBottomColor];
    }else if (weatherBackViewType == WHWeatherBackViewTypeRainNight) {
        backImage = [self getGradientImage:kRainNightTopColor and:kRainNightBottomColor];
    }
    
    [UIView animateWithDuration:kWeatherChangeAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        
                         if (backImage) {
                             self.weatherBackImageView.image = backImage;
                         }
                         
                         if (self.willDisplayView) {
                             [self.willDisplayView startAnimation];
                         }
                         
                         if (self.displayView) {
                             [self.displayView stopAnimation];
                         }
                         
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self.displayView removeFromSuperview];
                             self.displayView = nil;
                             self.displayView = self.willDisplayView;
                             [self addOrRemoveAnimationQueueWithType:YES addType:0];
                         }
                     }];
}

#pragma mark -
#pragma mark - Tools

- (UIImage *)getGradientImage:(UIColor *)color1 and:(UIColor *)color2
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,
                             (__bridge id)color2.CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    gradientLayer.frame = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

- (BOOL)isNowDayTime
{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
    if ([components hour] >= 19 || [components hour] < 6) {
        return NO;
    }else{
        return YES;
    }
}

- (WHWeatherType)getWeatherType:(NSInteger)type
{
    if (type >= 0 && type < 4) { //晴天
        return WHWeatherTypeSun;
    }
    else if (type >= 4 && type < 10) { //多云
        return WHWeatherTypeClound;
    }
    else if (type >= 10 && type < 20) { //雨
        if (type == 11 || type == 12 || type == 16 || type == 17 || type == 18) { //雷
            return WHWeatherTypeRainLighting;
        }
        return WHWeatherTypeRain;
    }
    else if (type >= 20 && type < 26) { //雪
        return WHWeatherTypeSnow;
    }
    else{
        return WHWeatherTypeOther;
    }
}

- (WHWeatherBackViewType)getWeatherBackViewType:(NSInteger)type
{
    BOOL isRain = NO;
    
    if (type >= 0 && type < 4) { //晴天
        isRain = NO;
    }
    else if (type >= 4 && type < 10) { //多云
        isRain = NO;
    }
    else if (type >= 10 && type < 20) { //雨
        isRain = YES;
    }
    else if (type >= 20 && type < 26) { //雪
        isRain = NO;
    }
    else{
        isRain = YES;
    }
    
    if ([self isNowDayTime]) {
        if (isRain) {
            return WHWeatherBackViewTypeRainDay;
        }else{
            return WHWeatherBackViewTypeSunDay;
        }
    }else{
        if (isRain) {
            return WHWeatherBackViewTypeRainDay;
        }else{
            return WHWeatherBackViewTypeSunDay;
        }
    }
}

#pragma mark -
#pragma mark - Getter
- (NSMutableArray *)animationArray
{
    if (!_animationArray) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

- (UIImageView *)weatherBackImageView
{
    if (!_weatherBackImageView) {
        _weatherBackImageView = [[UIImageView alloc] init];
        _weatherBackImageView.userInteractionEnabled = YES;
        _weatherBackImageView.clipsToBounds = YES;
    }
    return _weatherBackImageView;
}
@end
