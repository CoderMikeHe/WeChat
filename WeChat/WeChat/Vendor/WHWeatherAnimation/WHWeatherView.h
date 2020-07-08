//
//  WeatherView.h
//  SiShi
//
//  Created by whbalzac on 09/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WHWeatherType){
    WHWeatherTypeSun = 0,
    WHWeatherTypeClound = 1,
    WHWeatherTypeRain = 2,
    WHWeatherTypeRainLighting = 3,
    WHWeatherTypeSnow = 4,
    WHWeatherTypeOther = 5
};

@interface WHWeatherView : UIView
@property (nonatomic, strong) UIImageView *weatherBackImageView;

- (void)showWeatherAnimationWithType:(WHWeatherType)weatherType;
@end
