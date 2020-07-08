//
//  WHWeatherRainView.m
//  SiShi
//
//  Created by whbalzac on 13/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherRainView.h"
#import "WHWeatherLightingView.h"

@interface WHWeatherRainView ()
@property (nonatomic, strong) WHWeatherLightingView *lightingView;
@end

@implementation WHWeatherRainView

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
    self.lightingView = [[WHWeatherLightingView alloc] initWithFrame:self.bounds];
    [self addSubview:self.lightingView];
    
    for (NSInteger i = 0; i < 43; i++) {
        NSInteger randomInteger = arc4random()%3 + 1;
        UIImageView *rainLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ele_rainLine%ld.png", (long)randomInteger]]];
        rainLineView.tag = 100+i;
        
        if (randomInteger == 1) {
            rainLineView.frame = CGRectMake( arc4random() % 300 * widthPix , arc4random() % 400, 60, 218);
        }else if (randomInteger == 2) {
            rainLineView.frame = CGRectMake( arc4random() % 300 * widthPix , arc4random() % 400, 33, 118);
        }else {
            rainLineView.frame = CGRectMake( arc4random() % 300 * widthPix , arc4random() % 400, 33, 118);
        }
        
        [self addSubview:rainLineView];
        [rainLineView.layer addAnimation:[self rainAnimationWithDuration:2+i%5] forKey:nil];
        [rainLineView.layer addAnimation:[self rainAlphaWithDuration:2+i%5] forKey:nil];
    }
    
    [self addCloud:YES rainCount:kMaxWhiteCloudCount onView:self];
    
    self.layer.speed = 0.0;
}

-(void)startAnimation
{
    [super startAnimation];
    
    self.layer.speed = 1.0;
    if (self.isLighting) {
        [self.lightingView startAnimation];
    }
}

-(void)stopAnimation
{
    [super stopAnimation];
    
    [self.lightingView stopAnimation];
}

@end
