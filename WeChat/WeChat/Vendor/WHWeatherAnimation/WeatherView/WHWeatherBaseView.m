//
//  WHWeatherBaseView.m
//  SiShi
//
//  Created by whbalzac on 13/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherBaseView.h"
#import "WHWeatherHeader.h"

@implementation WHWeatherBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cloudArray = [NSMutableArray array];
        self.alpha = 0.0;
    }
    return self;
}

// will reload
-(void)startAnimation
{
    self.alpha = 1.0;
}

-(void)stopAnimation
{
    self.alpha = 0.0;
}

-(void)addCloud:(BOOL)isRain rainCount:(NSInteger)rainCount onView:(UIView *)view
{
    NSMutableArray *temp = [NSMutableArray array];
    if (rainCount == kMaxWhiteCloudCount) {
        for (int i = 0; i < rainCount; ++i) {
            [temp addObject:@(i)];
        }
        [temp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if (arc4random()%2) {
                return [obj1 compare:obj2];
            } else {
                return [obj2 compare:obj1];
            }
        }];
    }else{
        for (int i = 0; i < rainCount; ++i) {
            while (1) {
                NSInteger indexRow = arc4random() % kMaxWhiteCloudCount;
                if (![temp containsObject:@(indexRow)]) {
                    [temp addObject:@(indexRow)];
                    break;
                }
            }
        }
    }
    
    for (int i = 0; i < temp.count; ++i) {
        NSNumber *number = temp[i];
        UIImage *cloudImage;
        if (isRain) {
            cloudImage = [self imageNamed:[NSString stringWithFormat:@"ele_white_cloud_%ld.png",(long)number.integerValue] withTintColor:UIColorFromRGB(0, 51, 86)];
        }else{
            cloudImage = [UIImage imageNamed:[NSString stringWithFormat:@"ele_white_cloud_%ld.png",(long)number.integerValue]];
        }
        
        CGFloat offsetX = i * kOffsetXScreenCount / rainCount * kScreenWidth - (kOffsetXScreenCount - 1) / 2.0 * kScreenWidth;
        
        UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:cloudImage];
        cloudImageView.frame = CGRectMake(0, 0, 200.0 * cloudImage.size.width / cloudImage.size.height, 200);
        cloudImageView.center = CGPointMake(offsetX, kScreenHeight*0.05);
        [cloudImageView.layer addAnimation:[self cloudAnimationWithFromValue:@(offsetX) toValue:@(kOffsetXScreenCount) duration:kOffsetXAnimationTimes] forKey:nil];
        [view addSubview:cloudImageView];
        [self.cloudArray addObject:cloudImageView];
    }
}

- (CAAnimationGroup *)cloudAnimationWithFromValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue duration:(NSInteger)duration
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<40; ++i) {
        
        CGFloat offsetX = i / 40.0 * toValue.floatValue * kScreenWidth;
        
        if (offsetX + fromValue.floatValue < (kOffsetXScreenCount - 1) / 2.0 * kScreenWidth + kScreenWidth) {
            [temp addObject:@(offsetX)];
        }else{
            while (offsetX + fromValue.floatValue > (kOffsetXScreenCount - 1) / 2.0 * kScreenWidth + kScreenWidth) {
                offsetX = offsetX - kOffsetXScreenCount * kScreenWidth;
            }
            [temp addObject:@(offsetX)];
        }
    }
    [temp addObject:@(0.0)];
    keyAnimation.values = [NSArray arrayWithArray:temp];
    
    CAKeyframeAnimation *opacityKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    NSMutableArray *opacityTemp = [NSMutableArray array];
    for (NSNumber *number in temp) {
        if (number.floatValue + fromValue.floatValue < -(kOffsetXScreenCount - 1) / 4.0 * kScreenWidth || number.floatValue + fromValue.floatValue > (kOffsetXScreenCount - 1) / 4.0 * kScreenWidth + kScreenWidth) {
            [opacityTemp addObject:@(0.0)];
        }else{
            [opacityTemp addObject:@(1.0)];
        }
    }
    opacityKeyAnimation.values = [NSArray arrayWithArray:opacityTemp];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = duration;
    groupAnimation.animations = @[keyAnimation, opacityKeyAnimation];
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.fillMode = kCAFillModeForwards;
    
    return groupAnimation;
}

- (CABasicAnimation *)birdFlyAnimationWithToValue:(NSNumber *)toValue duration:(NSInteger)duration autoreverses:(BOOL)autoreverses
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = toValue;
    animation.duration = duration;
    animation.autoreverses = autoreverses;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CABasicAnimation *)sunshineAnimationWithDuration:(NSInteger)duration{
    
    CGFloat fromFloat = 0;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:fromFloat * M_PI];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(fromFloat + 2.0 ) * M_PI];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}

- (CABasicAnimation *)rainAnimationWithDuration:(NSInteger)duration{
    
    CABasicAnimation* caBaseTransform = [CABasicAnimation animation];
    caBaseTransform.duration = duration;
    caBaseTransform.keyPath = @"transform";
    caBaseTransform.repeatCount = MAXFLOAT;
    caBaseTransform.removedOnCompletion = NO;
    caBaseTransform.fillMode = kCAFillModeForwards;
    caBaseTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-170, -620, 0)];
    caBaseTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(kScreenHeight/2.0*34/124.0, kScreenHeight/2, 0)];
    
    return caBaseTransform;
    
}

- (CABasicAnimation *)rainAlphaWithDuration:(NSInteger)duration {
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.1];
    showViewAnn.duration = duration;
    showViewAnn.repeatCount = MAXFLOAT;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    
    return showViewAnn;
}

- (UIImage *)imageNamed:(NSString *)name withTintColor:(UIColor *)color {
    UIImage *img = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    [color set];
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
