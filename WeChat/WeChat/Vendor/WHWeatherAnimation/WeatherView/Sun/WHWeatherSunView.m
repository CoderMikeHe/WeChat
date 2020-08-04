//
//  WHWeatherSunView.m
//  SiShi
//
//  Created by whbalzac on 13/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherSunView.h"

@interface WHWeatherSunView ()
@property (nonatomic, strong) UIImageView *sunImageView;
@property (nonatomic, strong) UIImageView *sunshineImageView;
@end

@implementation WHWeatherSunView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

-(void)configureView
{
    self.sunImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_sunnySun"]];
    self.sunImageView.frame = CGRectMake(0, 0, 200, 200*579/612.0);
    self.sunImageView.center = CGPointMake(kScreenHeight * 0.1, kScreenHeight * 0.1);
    [self addSubview:self.sunImageView];
    [self.sunImageView.layer addAnimation:[self sunshineAnimationWithDuration:kRotationAnimationTimes] forKey:nil];
    
    self.sunshineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_sunnySunshine"]];
    self.sunshineImageView.frame = CGRectMake(0, 0, 600, 600);
    self.sunshineImageView.center = CGPointMake(kScreenHeight * 0.1, kScreenHeight * 0.1);
    [self addSubview:self.sunshineImageView];
    [self.sunshineImageView.layer addAnimation:[self sunshineAnimationWithDuration:kRotationAnimationTimes] forKey:nil];
    
    [self addCloud:NO rainCount:3 + arc4random()%3 onView:self];
    
    self.layer.speed = 0.0;
}

-(void)startAnimation
{
    [super startAnimation];
    
    self.layer.speed = 1.0;
}

-(void)stopAnimation
{
    [super stopAnimation];
}

@end
