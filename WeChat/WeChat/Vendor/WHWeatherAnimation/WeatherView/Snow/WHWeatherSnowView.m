//
//  WHWeatherSnowView.m
//  SiShi
//
//  Created by whbalzac on 13/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherSnowView.h"

@implementation WHWeatherSnowView

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
    for (NSInteger i = 0; i < 43; i++) {
        
        UIImageView *snowView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_snow.png"]];
        snowView.tag = 1000+i;
        
        snowView.frame = CGRectMake( arc4random() % 300 * widthPix , arc4random() % 400, arc4random()%7+3, arc4random()%7+3);
        [self addSubview:snowView];
        [snowView.layer addAnimation:[self rainAnimationWithDuration:5+i%5] forKey:nil];
        [snowView.layer addAnimation:[self rainAlphaWithDuration:5+i%5] forKey:nil];
        [snowView.layer addAnimation:[self sunshineAnimationWithDuration:5] forKey:nil];
    }
    
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
