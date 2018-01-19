//
//  MHControl.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHControl.h"

@implementation MHControl
{
    UIImage *_image;
    CGPoint _point;
    NSTimer *_timer;
    BOOL _longPressDetected;
}

- (void)dealloc
{
    [self _endTimer];
}

#pragma mark - Getter & Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image {
    id content = self.layer.contents;
    if (content != (id)_image.CGImage) {
        CGImageRef ref = (__bridge CGImageRef)(content);
        if (ref && CFGetTypeID(ref) == CGImageGetTypeID()) {
            _image = [UIImage imageWithCGImage:ref scale:self.layer.contentsScale orientation:UIImageOrientationUp];
        } else {
            _image = nil;
        }
    }
    return _image;
}


#pragma mark - 私有方法
- (void)_startTimer {
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(_timerFire) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)_endTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)_timerFire {
    [self touchesCancelled:[NSSet set] withEvent:nil];
    _longPressDetected = YES;
    if (_longPressBlock) _longPressBlock(self, _point);
    [self _endTimer];
}


#pragma mark - Override
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _longPressDetected = NO;
    if (_touchBlock) {
        _touchBlock(self, YYGestureRecognizerStateBegan, touches, event);
    }
    if (_longPressBlock) {
        UITouch *touch = touches.anyObject;
        _point = [touch locationInView:self];
        [self _startTimer];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_longPressDetected) return;
    if (_touchBlock) {
        _touchBlock(self, YYGestureRecognizerStateMoved, touches, event);
    }
    [self _endTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_longPressDetected) return;
    if (_touchBlock) {
        _touchBlock(self, YYGestureRecognizerStateEnded, touches, event);
    }
    [self _endTimer];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_longPressDetected) return;
    if (_touchBlock) {
        _touchBlock(self, YYGestureRecognizerStateCancelled, touches, event);
    }
    [self _endTimer];
}


@end
